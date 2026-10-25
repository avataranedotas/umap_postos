import json
import re
import sys


INPUT_FILE = "Todos.json"


def parse_number(value):
    """Extract a numeric value and optional unit from an OSM tag."""
    if value is None:
        return None

    match = re.fullmatch(
        r"\s*([0-9]+(?:[.,][0-9]+)?)\s*([a-zA-Z]*)\s*",
        str(value)
    )

    if not match:
        return None

    number = float(match.group(1).replace(",", "."))
    unit = match.group(2).lower()

    return number, unit


def parse_current(value):
    parsed = parse_number(value)
    if parsed is None:
        return None

    number, unit = parsed
    if unit not in ("", "a"):
        return None

    return number


def parse_voltage(value):
    parsed = parse_number(value)
    if parsed is None:
        return None

    number, unit = parsed
    if unit not in ("", "v"):
        return None

    return number


def parse_output(value):
    parsed = parse_number(value)
    if parsed is None:
        return None

    number, unit = parsed

    if unit in ("kw", "kilowatt", "kilowatts"):
        return number * 1000
    elif unit in ("w", "watt", "watts"):
        return number
    elif unit in ("mw",):
        return number * 1_000_000
    elif unit == "":
        # OSM charging output values without units are assumed to be kW.
        return number * 1000

    return None


def check_node(node):
    if node.get("type") != "node":
        return []

    tags = node.get("tags", {})
    problems = []

    # Find all socket types that have a :current tag.
    for key in tags:
        if not key.endswith(":current"):
            continue

        socket_type = key[:-len(":current")]

        voltage_key = socket_type + ":voltage"
        output_key = socket_type + ":output"

        # Only check socket types containing all three tags.
        if voltage_key not in tags or output_key not in tags:
            continue

        current = parse_current(tags[key])
        voltage = parse_voltage(tags[voltage_key])
        output = parse_output(tags[output_key])

        # Skip invalid or unparseable values.
        if current is None or voltage is None or output is None:
            print(
                "WARNING: Node {}: cannot parse values for {}".format(
                    node.get("id"), socket_type
                )
            )
            continue

        if socket_type in ("socket:type2", "socket:type2_cable", "socket:tesla_destination"):
            if voltage == 230:
                calculated_power = current * voltage
            elif voltage == 400:
                # Three-phase AC power
                calculated_power = (3 ** 0.5) * current * voltage
            else:
                # Other voltages: use the normal calculation
                calculated_power = current * voltage
        else:
            calculated_power = current * voltage

        if output > calculated_power *1.05:
            problems.append({
                "id": node.get("id"),
                "ref": tags.get("ref", ""),
                "socket": socket_type,
                "current": current,
                "voltage": voltage,
                "calculated_kw": calculated_power / 1000,
                "tagged_kw": output / 1000,
                "excess_kw": (output - calculated_power) / 1000,
            })

    return problems


def main():
    with open(INPUT_FILE, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Support both an Overpass JSON object and a JSON list of elements.
    elements = data.get("elements", []) if isinstance(data, dict) else data

    total_checked = 0
    all_problems = []

    for node in elements:
        if node.get("type") != "node":
            continue

        tags = node.get("tags", {})

        for key in tags:
            if key.endswith(":current"):
                socket_type = key[:-len(":current")]
                if (
                    socket_type + ":voltage" in tags
                    and socket_type + ":output" in tags
                ):
                    total_checked += 1

        all_problems.extend(check_node(node))

    print("Socket configurations checked:", total_checked)
    print("Inconsistent configurations:", len(all_problems))
    print()

    for p in all_problems:
        print(
            "Node {id} | {ref} | {socket}".format(**p)
        )
        print(
            "  Current: {current:g} A, Voltage: {voltage:g} V".format(**p)
        )
        print(
            "  Calculated maximum: {:.2f} kW".format(p["calculated_kw"])
        )
        print(
            "  Tagged output:      {:.2f} kW".format(p["tagged_kw"])
        )
        print(
            "  Excess:             {:.2f} kW".format(p["excess_kw"])
        )
        print()

    # Save the findings to a CSV file as well.
    import csv

    if all_problems:
        with open(
            "inconsistent_chargers.csv", "w", newline="", encoding="utf-8"
        ) as f:
            writer = csv.DictWriter(f, fieldnames=all_problems[0].keys())
            writer.writeheader()
            writer.writerows(all_problems)

        print("Results saved to inconsistent_chargers.csv")


if __name__ == "__main__":
    try:
        main()
    except (OSError, json.JSONDecodeError) as e:
        sys.exit("ERROR: {}".format(e))
