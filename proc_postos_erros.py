import json
from shapely.geometry import shape

def group_points_by_polygon(geojson_data):
    polygons = []
    points = []

    # 1. Separate features
    for feature in geojson_data['features']:
        geom = shape(feature['geometry'])
        feature_id = feature.get('id') or feature['properties'].get('@id', 'unknown')
        
        if "Polygon" in feature['geometry']['type']:
            polygons.append({
                'id': feature_id,
                'geometry': geom,
                'properties': feature['properties'],
                'points': []
            })
        elif feature['geometry']['type'] == 'Point':
            points.append({
                'id': feature_id,
                'geometry': geom,
                'properties': feature['properties']
            })

    # Configuration for whitelists
    poly_keys = {"man_made", "disused:man_made", "construction:man_made", "removed:man_made"}
    outside_keys = {"amenity", "disused:amenity", "construction:amenity", "removed:amenity"}
    
    invalid_points_report = []

    # 2. Process points
    for pt in points:
        # --- NEW GATEKEEPER CHECK ---
        # Only process points where motorcar=yes
        if pt['properties'].get('motorcar') != 'yes':
            continue  # Skip this point entirely
        # ----------------------------

        assigned = False
        
        # Check validity based on whitelists
        is_valid_inside = any(pt['properties'].get(k) == 'charge_point' for k in poly_keys)
        is_valid_outside = any(pt['properties'].get(k) == 'charging_station' for k in outside_keys)
        
        for poly in polygons:
            if poly['geometry'].contains(pt['geometry']):
                poly['points'].append({'id': pt['id'], 'properties': pt['properties']})
                
                if not is_valid_inside:
                    invalid_points_report.append({
                        'reason': 'Invalid inside polygon (missing man_made=charge_point)',
                        'point_id': pt['id'],
                        'polygon_id': poly['id'],
                        'properties': pt['properties']
                    })
                assigned = True
                break
        
        if not assigned:
            if not is_valid_outside:
                invalid_points_report.append({
                    'reason': 'Invalid outside polygon (missing amenity=charging_station)',
                    'point_id': pt['id'],
                    'polygon_id': 'N/A',
                    'properties': pt['properties']
                })

    # 3. Final Result Structure
    return {
        'grouped_data': {p['id']: {'properties': p['properties'], 'points': p['points']} for p in polygons},
        'invalid_points_report': invalid_points_report
    }

if __name__ == "__main__":
    input_file = 'Todos.geojson'
    output_main = 'points_grouped.json'
    output_filtered = 'non_charge_points_report.json'

    try:
        with open(input_file) as f:
            data = json.load(f)

        full_results = group_points_by_polygon(data)

        # Save the main grouped file
        #with open(output_main, 'w', encoding='utf-8') as f_out:
        #    json.dump(full_results['grouped_data'], f_out, indent=2, ensure_ascii=False)

        # Save the specific "invalid/non-charge" list
        with open(output_filtered, 'w', encoding='utf-8') as f_out:
            json.dump(full_results['invalid_points_report'], f_out, indent=2, ensure_ascii=False)

        print(f"Success!")
        #print(f"- Grouped data saved to: {output_main}")
        print(f"- Found {len(full_results['invalid_points_report'])} points that don't match the required tags.")
        print(f"- Report saved to: {output_filtered}")
        
    except FileNotFoundError:
        print(f"Error: Could not find {input_file}")
