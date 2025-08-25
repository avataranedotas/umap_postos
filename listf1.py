import json
import csv

# Load the JSON file
with open("points_grouped_by_polygon_with_unassigned.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# CSV output file
output_file = "all.csv"
child_csv_file = "points.csv"
public_file = "points_public.csv"


# Define CSV headers
headers = [
    "identifier", "type", "id", "construction/disused", "latitude", "longitude", "operator", "access", "opening_hours", "network",
    "addr:street", "addr:city", "addr:postcode", "addr:country", "phone", "website", "socket:chademo", "socket:chademo:current", "socket:chademo:output", "socket:chademo:voltage", "socket:tesla_destination", 
    "socket:tesla_destination:current", "socket:tesla_destination:output", "socket:tesla_destination:voltage", 
    "socket:tesla_supercharger_ccs", "socket:tesla_supercharger_ccs:current", "socket:tesla_supercharger_ccs:output", "socket:tesla_supercharger_ccs:voltage", 
    "socket:type2", "socket:type2:current", "socket:type2:output", "socket:type2:voltage", "socket:type2_cable", "socket:type2_cable:current", 
    "socket:type2_cable:output", "socket:type2_cable:voltage", "socket:type2_combo", "socket:type2_combo:current", "socket:type2_combo:output", "socket:type2_combo:voltage",
    
]

def extract_sockets(properties):
    """Extract socket counts, defaulting to 0 if missing."""
    return {
        "socket:chademo": int(properties.get("socket:chademo", 0)),
        "socket:chademo:current": properties.get("socket:chademo:current", 0),
        "socket:chademo:output": properties.get("socket:chademo:output", 0),
        "socket:chademo:voltage": properties.get("socket:chademo:voltage", 0),
        "socket:tesla_destination": int(properties.get("socket:tesla_destination", 0)),
        "socket:tesla_destination:current": properties.get("socket:tesla_destination:current", 0),
        "socket:tesla_destination:output": properties.get("socket:tesla_destination:output", 0),
        "socket:tesla_destination:voltage": properties.get("socket:tesla_destination:voltage", 0),
        "socket:tesla_supercharger_ccs": int(properties.get("socket:tesla_supercharger_ccs", 0)),
        "socket:tesla_supercharger_ccs:current": properties.get("socket:tesla_supercharger_ccs:current", 0),
        "socket:tesla_supercharger_ccs:output": properties.get("socket:tesla_supercharger_ccs:output", 0),
        "socket:tesla_supercharger_ccs:voltage": properties.get("socket:tesla_supercharger_ccs:voltage", 0),
        "socket:type2": int(properties.get("socket:type2", 0)),
        "socket:type2:current": properties.get("socket:type2:current", 0),
        "socket:type2:output": properties.get("socket:type2:output", 0),
        "socket:type2:voltage": properties.get("socket:type2:voltage", 0),
        "socket:type2_cable": int(properties.get("socket:type2_cable", 0)),
        "socket:type2_cable:current": properties.get("socket:type2_cable:current", 0),
        "socket:type2_cable:output": properties.get("socket:type2_cable:output", 0),
        "socket:type2_cable:voltage": properties.get("socket:type2_cable:voltage", 0),
        "socket:type2_combo": int(properties.get("socket:type2_combo", 0)),
        "socket:type2_combo:current": properties.get("socket:type2_combo:current", 0),
        "socket:type2_combo:output": properties.get("socket:type2_combo:output", 0),
        "socket:type2_combo:voltage": properties.get("socket:type2_combo:voltage", 0),
        "operator": properties.get("operator", ""),
        "phone": properties.get("phone", ""),
        "website": properties.get("website", ""),
        "addr:street": properties.get("addr:street", ""),
        "addr:city": properties.get("addr:city", ""),
        "addr:postcode": properties.get("addr:postcode", ""),
        "addr:country": properties.get("addr:country", ""),
    }

rows = []
rows_children = []


# Process ways and their child points
for way_id, way_data in data.items():
    if not way_id.startswith("way/"):
        continue
    props = way_data.get("properties", {})
    
    # Determine way identifier: name if exists, else ref
    way_identifier = props.get("name") or props.get("ref") or way_id
    
    lat, lon = way_data.get("centroid", [None, None])
    
    # Determine construction/disused for way
    construction = "no" if props.get("amenity") == "charging_station" else "yes"
    
    # Way row
    rows.append({
        "identifier": way_identifier,
        "type": "way",
        "id": way_id,
        "access": props.get("access", ""),
        "opening_hours": props.get("opening_hours", ""),
        "network": props.get("network", ""),
        "construction/disused": construction,
        "latitude": lat,
        "longitude": lon
    })
    
    # Child points
    for point in way_data.get("points", []):
        p_props = point.get("properties", {})
        sockets = extract_sockets(p_props)
        # Hack: use parent centroid
        lat, lon = way_data.get("centroid", [None, None])

        # Determine child identifier: parent_identifier / child_name_or_ref
        #child_identifier = f"{way_identifier} / {p_props.get('name') or p_props.get('ref') or point.get('id')}"
        child_name = p_props.get('name') or p_props.get('ref') or point.get('id')
        if child_name != way_identifier:
            child_identifier = f"{way_identifier} -> {child_name}"
        else:
            child_identifier = child_name

        # Determine construction/disused for child
        construction = "no" if p_props.get("man_made") == "charge_point" else "yes"
        child_row = {
        
            "identifier": child_identifier,
            "type": "child_point",
            "id": f"child/{point.get('id','')}",
            "access": p_props.get("access", ""),
            "opening_hours": p_props.get("opening_hours", ""),
            "network": p_props.get("network", ""),
            "construction/disused": construction,
            **sockets,
            "latitude": lat,
            "longitude": lon
        }
        rows.append(child_row)
        rows_children.append(child_row)

# Process unassigned points
for point in data.get("unassigned_points", []):
    p_props = point.get("properties", {})
    sockets = extract_sockets(p_props)
    lat, lon = point.get("coordinates", [None, None])
    # identifier: name if exists else ref
    point_identifier = p_props.get("name") or p_props.get("ref") or point.get("id")
    # construction/disused for unassigned point
    construction = "no" if p_props.get("amenity") == "charging_station" else "yes"
    urow = {
        "identifier": point_identifier,
        "type": "unassigned_point",
        "id": point.get("id", ""),
        "access": p_props.get("access", ""),
        "opening_hours": p_props.get("opening_hours", ""),
        "network": p_props.get("network", ""),
        "construction/disused": construction,
        **sockets,
        "latitude": lat,
        "longitude": lon
        }
    rows.append(urow)
    rows_children.append(urow)

# Sort children/unassigned CSV by parent identifier (before first '/')
def get_parent_identifier(row):
    return row['identifier'].split(" / ")[0]
    
rows_children.sort(key=get_parent_identifier)

# Filter rows_children for the third CSV
filtered_rows = [
    row for row in rows_children
    if row.get("construction/disused") == "no" and row.get("access") == "yes"
]


# Write CSV
with open(output_file, "w", newline="", encoding="utf-8") as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=headers)
    writer.writeheader()
    writer.writerows(rows)

# Write child/unassigned CSV
with open(child_csv_file, "w", newline="", encoding="utf-8") as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=headers)
    writer.writeheader()
    writer.writerows(rows_children)

# Write filtered CSV
with open(public_file, "w", newline="", encoding="utf-8") as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=headers)
    writer.writeheader()
    writer.writerows(filtered_rows)

print(f"CSV exported to {output_file} (full) and {child_csv_file} (children only, sorted by parent) and {public_file}")

