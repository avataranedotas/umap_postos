#!/bin/bash

echo "PCN"
wget -O Type2s.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(nwr%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22socket%3Atype2_combo%22!~%22.*%22%5D%5B%22motorcar%22%3D%22yes%22%5D(area.searchArea)%3Bnwr%5B%22man_made%22%3D%22charge_point%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22socket%3Atype2_combo%22!~%22.*%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D(area.searchArea)%3B)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

echo "PCR"
wget -O PCR.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anwr%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3C150)(area.searchArea)%3B%0Anwr%5B%22man_made%22%3D%22charge_point%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3C150)(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

echo "PCUR1"
wget -O PCSR.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anwr%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3E149)(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3C350)(area.searchArea)%3B%0Anwr%5B%22man_made%22%3D%22charge_point%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3E149)(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3C350)(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

echo "PCUR2"
wget -O PCUR.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anwr%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3E349)(area.searchArea)%3B%0Anwr%5B%22man_made%22%3D%22charge_point%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3E349)(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

echo "SuC"
wget -O SuC.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anwr%5B%22amenity%22%3D%22charging_station%22%5D%5B~%22socket%3Atesla_supercharger%22~%22.*%22%5D(area.searchArea)%3B%0Anwr%5B%22man_made%22%3D%22charge_point%22%5D%5B~%22socket%3Atesla_supercharger%22~%22.*%22%5D(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B'
sleep 30

echo "inop"
wget -O inop.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anwr%5B%22disused%3Aamenity%22%3D%22charging_station%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D(area.searchArea)%3B%0Anwr%5B%22disused%3Aman_made%22%3D%22charge_point%22%5D%5B%22motorcar%22%3D%22yes%22%5D(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

echo "plan"
wget -O plan.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(nwr%5B%22planned%3Aamenity%22%3D%22charging_station%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D(area.searchArea)%3Bnwr%5B%22planned%3Aman_made%22%3D%22charge_point%22%5D%5B%22motorcar%22%3D%22yes%22%5D(area.searchArea)%3B)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B'
sleep 30

echo "const"
wget -O const.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(nwr%5B%22construction%3Aamenity%22%3D%22charging_station%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D(area.searchArea)%3Bnwr%5B%22construction%3Aman_made%22%3D%22charge_point%22%5D%5B%22motorcar%22%3D%22yes%22%5D(area.searchArea)%3B)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B'
sleep 30

echo "Privados"
wget -O Privados.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anwr%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22!%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22socket%3Atesla_supercharger%22!~%22.*%22%5D%5B%22socket%3Atesla_supercharger_ccs%22!~%22.*%22%5D(area.searchArea)%3B%0Anode%5B%22man_made%22%3D%22charge_point%22%5D%5B%22access%22!%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B%22socket%3Atesla_supercharger%22!~%22.*%22%5D%5B%22socket%3Atesla_supercharger_ccs%22!~%22.*%22%5D(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

echo "NotAuto"
wget -O NotAuto.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(nwr%5B%22access%22~%22%5E(yes%7Cpermissive)%24%22%5D%5B%22amenity%22%3D%22charging_station%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22socket%3Atesla_destination%22!~%22.%22%5D%5B%22socket%3Atype2%22!~%22.%22%5D%5B%22socket%3Achademo%22!~%22.%22%5D%5B%22socket%3Atype2_combo%22!~%22.%22%5D%5B%22socket%3Atype2_cable%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger_ccs%22!~%22.%22%5D(area.searchArea)%3Bnwr%5B%22access%22~%22%5E(yes%7Cpermissive)%24%22%5D%5B%22man_made%22%3D%22charge_point%22%5D%5B%22socket%3Atesla_destination%22!~%22.%22%5D%5B%22socket%3Atype2%22!~%22.%22%5D%5B%22socket%3Achademo%22!~%22.%22%5D%5B%22socket%3Atype2_combo%22!~%22.%22%5D%5B%22socket%3Atype2_cable%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger_ccs%22!~%22.%22%5D(area.searchArea)%3B)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B'
sleep 30

echo "Areas"
wget -O Areas.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Away%5B%22amenity%22%3D%22charging_station%22%5D%5B%22motorcar%22%3D%22yes%22%5D(area.searchArea)%3B%0A)%3Bout%20geom%3B%0A'
sleep 30

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
osmtogeojson Areas.json >| Areas.geojson

echo "Todos"
wget -O Todos.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A60%5D%3B%0Aarea(id%3A3600295480)-%3E.searchArea%3B%0A(%0Anwr%5B%22construction%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B%0Anwr%5B%22amenity%22%3D%22charging_station%22%5D(area.searchArea)%3B%0Anwr%5B%22disused%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B%0Anwr%5B%22removed%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B%0Anwr%5B%22man_made%22%3D%22charge_point%22%5D(area.searchArea)%3B%0Anwr%5B%22construction%3Aman_made%22%3D%22charge_point%22%5D(area.searchArea)%3B%0Anwr%5B%22disused%3Aman_made%22%3D%22charge_point%22%5D(area.searchArea)%3B%0Anwr%5B%22removed%3Aman_made%22%3D%22charge_point%22%5D(area.searchArea)%3B%0A)%3B%0Aout%20body%3B%0A%3E%3B%0Aout%20skel%20qt%3B'
sleep 30

osmtogeojson Todos.json >| Todos.geojson
