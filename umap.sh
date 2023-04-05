#!/bin/bash

#Type2 e Type2_cable


echo "Type2s"
wget -O Type2s.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B%0A((%20%20node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22socket%3Atype2_combo%22!~%22.*%22%5D%5B%22socket%3Achademo%22!~%22.*%22%5D%0A%20%20(if%3A%20t%5B%22socket%3Atype2%22%5D%20%3E%200)%20%20%20%20(area.searchArea)%3B)%3B%0A(%20%20node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22socket%3Atype2_combo%22!~%22.*%22%5D%5B%22socket%3Achademo%22!~%22.*%22%5D%0A%20%20(if%3A%20t%5B%22socket%3Atype2_cable%22%5D%20%3E%200)%20%20%20%20(area.searchArea)%3B)%3B)%3B%0Aout%20body%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 60

echo "PCR"
wget -O PCR.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B%0A((%20%20node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2_combo%22%5D%20%3E%200)%20%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3C%2076)%20(area.searchArea)%3B)%3B%0A(%20%20node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22socket%3Atype2_combo%22!~%22.*%22%5D(if%3A%20t%5B%22socket%3Achademo%22%5D%20%3E%200)%20%20%20%20(area.searchArea)%3B)%3B)%3B%0Aout%20body%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 60

echo "PCSR"
wget -O PCSR.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2_combo%22%5D%20%3E%200)%20%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3E%2074%20)(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3C%20150%20)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "PCUR"
wget -O PCUR.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D(if%3A%20t%5B%22socket%3Atype2_combo%22%5D%20%3E%200)%20%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D%20(if%3A%20number%20(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%20%3E149%20)%20(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "SuC"
wget -O SuC.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B%0A((%20%20node%5B%22amenity%22%3D%22charging_station%22%5D%0A%20%20(if%3A%20t%5B%22socket%3Atesla_supercharger%22%5D%20%3E%200)%20%20%20%20(area.searchArea)%3B)%3B%0A(%20%20node%5B%22amenity%22%3D%22charging_station%22%5D%0A%20%20(if%3A%20t%5B%22socket%3Atesla_supercharger_ccs%22%5D%20%3E%200)%20%20%20%20(area.searchArea)%3B)%3B)%3B%0Aout%20body%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 60

echo "inop"
wget -O inop.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22disused%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "plan"
wget -O plan.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22planned%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "const"
wget -O const.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22construction%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60

echo "Privados"
wget -O Privados.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B%0A(%0A%20%20(%20%20node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22!%3D%22yes%22%5D%0A%20%20(if%3A%20t%5B%22socket%3Atype2%22%5D%20%3E%200)%20%20%20%20(area.searchArea)%3B)%3B%0A(%20%20node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22!%3D%22yes%22%5D%0A%20%20(if%3A%20t%5B%22socket%3Atype2_cable%22%5D%20%3E%200)%20%20%20%20(area.searchArea)%3B)%3B%0A(%20%20node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22!%3D%22yes%22%5D%0A%20%20(if%3A%20t%5B%22socket%3Atype2_combo%22%5D%20%3E%200)%20%20%20%20(area.searchArea)%3B)%3B%0A(%20%20node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22!%3D%22yes%22%5D%0A%20%20(if%3A%20t%5B%22socket%3Achademo%22%5D%20%3E%200)%20%20%20%20(area.searchArea)%3B)%3B%0A)%3B%0Aout%20body%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 60

echo "NotAuto"
wget -O NotAuto.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22socket%3Atesla_destination%22!~%22.%22%5D%5B%22socket%3Atype2%22!~%22.%22%5D%5B%22socket%3Achademo%22!~%22.%22%5D%5B%22socket%3Atype2_combo%22!~%22.%22%5D%5B%22socket%3Atype2_cable%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger_ccs%22!~%22.%22%5D(area.searchArea)%3B)%3Bout%20body%3B%3E%3Bout%20skel%20qt%3B'
sleep 60
sed -i '/.*timestamp_.*/d' *.json

osmtogeojson NotAuto.json >| NotAuto.geojson
osmtogeojson inop.json >| inop.geojson
osmtogeojson plan.json >| plan.geojson
osmtogeojson const.json >| const.geojson
osmtogeojson Privados.json >| Privados.geojson
osmtogeojson PCUR.json >| PCUR.geojson
osmtogeojson PCSR.json >| PCSR.geojson
osmtogeojson PCR.json >| PCR.geojson
osmtogeojson Type2s.json >| Type2s.geojson
osmtogeojson SuC.json >| SuC.geojson


