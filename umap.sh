#!/bin/bash

echo "ns"
wget -O ns.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22socket%3Atesla_destination%22!~%22.%22%5D%5B%22socket%3Atype2%22!~%22.%22%5D%5B%22socket%3Achademo%22!~%22.%22%5D%5B%22socket%3Atype2_combo%22!~%22.%22%5D%5B%22socket%3Atype2_cable%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger_ccs%22!~%22.%22%5D(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "inop"
wget -O inop.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22disused%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "plan"
wget -O plan.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22planned%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "const"
wget -O const.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22construction%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "CCS_300-kW"
wget -O CCS_300-kW.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2_combo%22%5D%20%3E%200)%20%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3E%20299%20)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 60

echo "CCS_200-299kW"
wget -O CCS_200-299kW.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2_combo%22%5D%20%3E%200)%20%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3E%20199%20)(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3C%20299%20)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "CCS_100-199kW"
wget -O CCS_100-199kW.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2_combo%22%5D%20%3E%200)%20%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3E%2099%20)(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3C%20200%20)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "CCS_45-99kW"
wget -O CCS_45-99kW.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2_combo%22%5D%20%3E%200)%20%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3E%2044%20)(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3C%20100%20)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "CCS_0-44kW"
wget -O CCS_0-44kW.json 'https://z.overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2_combo%22%5D%20%3E%200)%20%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3C%2045%20)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

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

osmtogeojson ns.json >| ns.geojson
osmtogeojson inop.json >| inop.geojson
osmtogeojson plan.json >| plan.geojson
osmtogeojson const.json >| const.geojson
osmtogeojson CCS_300-kW.json >| CCS_300-kW.geojson
osmtogeojson CCS_200-299kW.json >| CCS_200-299kW.geojson
osmtogeojson CCS_100-199kW.json >| CCS_100-199kWW.geojson
osmtogeojson CCS_45-99kW.json >| CCS_45-99kW.geojson
osmtogeojson CCS_0-44kW.json >| CCS_0-44kW.geojson
osmtogeojson CDM_45-99kW.json >| CDM_45-99kW.geojson
osmtogeojson CDM_0-44kW.json >| CDM_0-44kW.geojson
osmtogeojson Type2_cable_23-kW.json >| Type2_cable_23-kW.geojson
osmtogeojson Type2_0-10kW.json >| Type2_0-10kW.geojson
osmtogeojson Type2_11-22kW.json >| Type2_11-22kW.geojson
osmtogeojson Type2_cable_0-22kW.json >| Type2_cable_0-22kW.geojson

