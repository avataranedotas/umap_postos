import json
from shapely.geometry import shape, Point

def group_points_by_polygon(geojson_data):
    polygons = []
    points = []

    # Separate polygons and points, store geometries, ids, and polygon properties
    for feature in geojson_data['features']:
        geom = shape(feature['geometry'])
        feature_id = feature.get('id') or feature['properties'].get('@id')
        if feature['geometry']['type'] == 'Polygon':
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

    unassigned_points = []

    # Assign points to polygons they fall inside
    for pt in points:
        assigned = False
        for poly in polygons:
            if poly['geometry'].contains(pt['geometry']):
                poly['points'].append({'id': pt['id'], 'properties': pt['properties'],'coordinates': [pt['geometry'].y, pt['geometry'].x]})
                assigned = True
                break  # Each point belongs to at most one polygon
        if not assigned:
            unassigned_points.append({'id': pt['id'], 'properties': pt['properties'],'coordinates': [pt['geometry'].y, pt['geometry'].x]})

    # Build result dict with polygon properties and points
    result = {}
    for poly in polygons:
        centroid = poly['geometry'].centroid
        result[poly['id']] = {
            'properties': poly['properties'],
            'centroid': [centroid.y, centroid.x],  # [lon, lat]
            'points': poly['points']
        }

    # Add unassigned points under a special key
    result['unassigned_points'] = unassigned_points

    return result

if __name__ == "__main__":
    input_file = 'Todos.geojson'
    output_file = 'points_grouped_by_polygon_with_unassigned.json'

    with open(input_file, "r", encoding="utf-8") as f:    
        data = json.load(f)

    groups = group_points_by_polygon(data)

    with open(output_file, 'w', encoding='utf-8') as f_out:
        json.dump(groups, f_out, indent=2, ensure_ascii=False)

    print(f"Grouped points with polygon properties and unassigned points saved to {output_file}")
