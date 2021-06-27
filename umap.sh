#!/bin/bash

echo "CDM_45-99kW"
wget -O CDM_45-99kW.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Achademo%22%5D%20%3E%200)%20%5B%22socket%3Achademo%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Achademo%3Aoutput%22%5D)%20%3C%20100%20)(if%3A%20number%20(t%5B%22socket%3Achademo%3Aoutput%22%5D)%20%3E%2044%20)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "CDM_0-44kW"
wget -O CDM_0-44kW.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Achademo%22%5D%20%3E%200)%20%5B%22socket%3Achademo%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Achademo%3Aoutput%22%5D)%20%3C%2045%20)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "Type2_cable_23-kW"
wget -O Type2_cable_23-kW.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2_cable%22%5D%20%3E%200)%20%5B%22socket%3Atype2_cable%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2_cable%3Aoutput%22%5D)%20%3E%2022%20)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "Type2_0-10kW"
wget -O Type2_0-10kW.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2%22%5D%20%3E%200)%20%5B%22socket%3Atype2%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2%3Aoutput%22%5D)%20%3C%2011)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "Type2_11-22kW"
wget -O Type2_11-22kW.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2%22%5D%20%3E%200)%20%5B%22socket%3Atype2%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2%3Aoutput%22%5D)%20%3C%2023)(if%3A%20number%20(t%5B%22socket%3Atype2%3Aoutput%22%5D)%20%3E%2010)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "Type2_cable_0-22kW"
wget -O Type2_cable_0-22kW.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2_cable%22%5D%20%3E%200)%20%5B%22socket%3Atype2_cable%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2_cable%3Aoutput%22%5D)%20%3C%2023)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

sed -i '/.*timestamp_.*/d' *.json

osmtogeojson CDM_45-99kW.json >| CDM_45-99kW.geojson
osmtogeojson CDM_0-44kW.json >| CDM_0-44kW.geojson
osmtogeojson Type2_cable_23-kW.json >| Type2_cable_23-kW.geojson
osmtogeojson Type2_0-10kW.json >| Type2_0-10kW.geojson
osmtogeojson Type2_11-22kW.json >| Type2_11-22kW.geojson
osmtogeojson Type2_cable_0-22kW.json >| Type2_cable_0-22kW.geojson

