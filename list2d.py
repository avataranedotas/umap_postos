import json
import csv
import re
from collections import defaultdict

ALLOWED_SOCKETS = {
    "socket:chademo",
    "socket:tesla_destination",
    "socket:tesla_supercharger_ccs",
    "socket:type2",
    "socket:type2_cable",
    "socket:type2_combo"
}

def get_identifier(props, fallback_id):
    if 'name' in props and props['name']:
        return props['name']
    elif 'ref' in props and props['ref']:
        return props['ref']
    else:
        return fallback_id

def parse_capacity(value):
    try:
        return int(value)
    except (TypeError, ValueError):
        return 0

def get_numeric_output(value):
    """Extract numeric part of a string and return as float."""
    if value is None:
        return 0.0
    match = re.search(r'[\d\.]+', str(value))
    return float(match.group(0)) if match else 0.0

def extract_sockets_and_kw(data):
    """
    Accepts either:
      - a list of points (each with 'properties' dict), or
      - a single properties dict
    Returns: (socket_counts, total_sockets, total_kw)
    """
    if isinstance(data, dict):
        points = [{'properties': data}]
    elif isinstance(data, list):
        points = data
    else:
        raise ValueError("Invalid data type for extract_sockets_and_kw")

    total_sockets = 0
    total_kw = 0.0
    socket_counts = defaultdict(int)

    for p in points:
        props = p.get('properties', {})
        for sock in ALLOWED_SOCKETS:
            count = int(float(props.get(sock, 0))) if props.get(sock) else 0
            output = get_numeric_output(props.get(f"{sock}:output"))
            socket_counts[sock] += count
            total_sockets += count
            total_kw += count * output

    return dict(socket_counts), total_sockets, round(total_kw, 2)

def compute_overflow_power(socket_counts, socket_outputs, overflow):
    if overflow <= 0:
        return 0.0

    # Build list of (socket_type, power) tuples
    power_list = []
    for sock_type, count in socket_counts.items():
        output_key = f"{sock_type}:output"
        power = socket_outputs.get(output_key, 0.0)
        if power > 0:
            power_list.append((sock_type, power))

    # Sort by ascending power (lowest first)
    power_list.sort(key=lambda x: x[1])

    overflow_power = 0.0
    overflow_left = overflow

    for sock_type, power in power_list:
        count = socket_counts.get(sock_type, 0)
        assign = min(overflow_left, count)
        overflow_power += assign * power
        overflow_left -= assign
        if overflow_left <= 0:
            break

    return round(overflow_power, 2)

def compute_adjusted_kw(total_kw, overflow_power, charging_station_output):
    """
    Use charging_station_output only if it's a positive numeric value.
    Otherwise return total_kw - overflow_power (rounded).
    """
    try:
        val = float(charging_station_output)
    except (ValueError, TypeError):
        val = None

    if val is not None and val > 0:
        return round(val, 2)
    return round(total_kw - overflow_power, 2)

# Load JSON
with open('points_grouped_by_polygon_with_unassigned.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

rows = []
all_socket_types = set()

# Process ways
for way_id, way_data in data.items():
    if way_id == "unassigned_points":
        continue

    props = way_data.get('properties', {})
    if props.get('amenity') != "charging_station":
        continue
    if props.get('motorcar') != 'yes':
        continue

    identifier = get_identifier(props, way_id)
    way_capacity = parse_capacity(props.get('capacity'))
    output = get_numeric_output(props.get('charging_station:output'))
    access = props.get('access', '')

    child_points = way_data.get('points', [])

    #missing_tag = any(
    #    p.get('properties', {}).get('man_made') != 'charge_point'
    #    for p in child_points
    #)

    valid_points = [
        p for p in child_points
        if p.get('properties', {}).get('man_made') == 'charge_point'
    ]

    missing_tag = len(valid_points) == 0

    socket_counts, total_sockets, total_kw = extract_sockets_and_kw(valid_points)
    all_socket_types.update(socket_counts.keys())

    overflow = total_sockets - way_capacity

    # Extract socket outputs for overflow calculation
    socket_outputs = defaultdict(float)
    for p in valid_points:
        pprops = p.get('properties', {})
        for k, v in pprops.items():
            if k.endswith(':output'):
                base_key = k.rsplit(":", 1)[0]
                if base_key in ALLOWED_SOCKETS:
                    num_val = get_numeric_output(v)
                    socket_outputs[k] = max(socket_outputs[k], num_val)

    overflow_power_agg = 0.0

    row = {
        'identifier': identifier,
        'type': 'way',
        'id': way_id,
        'capacity': way_capacity,
        'charging_station:output': output,
        'access': access,
        'payment:cards': props.get('payment:cards', ''),
        'opening_hours': props.get('opening_hours', ''),
        'network': props.get('network', ''),
        'total_sockets': total_sockets,
        'total_kw': total_kw,
        'flag_missing_tag': 'yes' if missing_tag else 'no',
        'overflow': overflow,
        'overflow_power': 0.0,
    }
    row.update(socket_counts)
    row['adjusted_kw'] = 0.0
    rows.append(row)

    # Process child points
    for child_point in valid_points:
        cprops = child_point.get('properties', {})
        child_socket_counts, child_total_sockets, child_total_kw = extract_sockets_and_kw(cprops)

        child_socket_outputs = {}
        for k, v in cprops.items():
            if k.endswith(':output'):
                base_key = k.rsplit(":", 1)[0]
                if base_key in ALLOWED_SOCKETS:
                    num_val = get_numeric_output(v)
                    child_socket_outputs[k] = num_val

        child_id = child_point.get('id', '')
        child_capacity = parse_capacity(cprops.get('capacity'))
        child_identifier = f"{identifier} / {get_identifier(cprops, child_id)}"
        child_missing_tag = 'yes' if cprops.get('man_made') != 'charge_point' else 'no'
        child_output = get_numeric_output(cprops.get('charge_point:output'))

        child_overflow = child_total_sockets - child_capacity
        child_overflow_power = compute_overflow_power(child_socket_counts, child_socket_outputs, child_overflow)
        overflow_power_agg += child_overflow_power

        child_row = {
            'identifier': child_identifier,
            'type': 'child_point',
            'id': f"child/{child_id}",
            'capacity': child_capacity,
            'charging_station:output': child_output,
            'access': access,
            'payment:cards': cprops.get('payment:cards', ''),
            'opening_hours': cprops.get('opening_hours', ''),
            'network': cprops.get('network', ''),
            'total_sockets': child_total_sockets,
            'total_kw': child_total_kw,
            'flag_missing_tag': child_missing_tag,
            'overflow': child_overflow,
            'overflow_power': child_overflow_power
        }
        child_row.update(child_socket_counts)
        child_row['adjusted_kw'] = compute_adjusted_kw(child_total_kw, child_overflow_power, child_output)
        rows.append(child_row)

    # Update way with aggregated child overflow
    rows[-(len(valid_points) + 1)]['overflow_power'] = round(overflow_power_agg, 2)
    rows[-(len(valid_points) + 1)]['adjusted_kw'] = compute_adjusted_kw(
        rows[-(len(valid_points) + 1)]['total_kw'],
        overflow_power_agg,
        output
    )

# Process unassigned points
for point in data.get('unassigned_points', []):
    pprops = point.get('properties', {})
    if pprops.get('motorcar') != 'yes':
        continue

    pid = get_identifier(pprops, point.get('id', ''))
    capacity = parse_capacity(pprops.get('capacity'))
    output = get_numeric_output(pprops.get('charging_station:output'))
    access = pprops.get('access', '')
    missing_tag = pprops.get('amenity') != 'charging_station'

    socket_counts, total_sockets, total_kw = extract_sockets_and_kw(pprops)

    socket_outputs = {}
    for k, v in pprops.items():
        if k.endswith(':output'):
            base_key = k.rsplit(":", 1)[0]
            if base_key in ALLOWED_SOCKETS:
                num_val = get_numeric_output(v)
                socket_outputs[k] = num_val

    overflow = total_sockets - capacity
    overflow_power = compute_overflow_power(socket_counts, socket_outputs, overflow)
    all_socket_types.update(socket_counts.keys())

    row = {
        'identifier': pid,
        'type': 'unassigned_point',
        'id': point.get('id', ''),
        'capacity': capacity,
        'charging_station:output': output,
        'access': access,
        'payment:cards': pprops.get('payment:cards', ''),
        'opening_hours': pprops.get('opening_hours', ''),
        'network': pprops.get('network', ''),
        'total_sockets': total_sockets,
        'total_kw': total_kw,
        'flag_missing_tag': 'yes' if missing_tag else 'no',
        'overflow': overflow,
        'overflow_power': overflow_power,
        'adjusted_kw': compute_adjusted_kw(total_kw, overflow_power, output)
    }
    row.update(socket_counts)
    rows.append(row)

# CSV output
fieldnames = [
    'identifier', 'type', 'id', 'capacity', 'charging_station:output',
    'access', 'payment:cards', 'opening_hours', 'network', 'total_sockets', 'total_kw', 'flag_missing_tag', 'overflow',
    'overflow_power', 'adjusted_kw'
] + sorted(all_socket_types)

with open('stations.csv', 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    for row in rows:
        writer.writerow(row)

print(f"CSV file 'stations.csv' created with {len(rows)} entries. Socket types: {sorted(all_socket_types)}")

