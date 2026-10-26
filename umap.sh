#!/bin/bash



download_json() {
    local output="$1"
    local url="$2"
    local tmp="${output}.tmp"
    local attempt
    local max_attempts=5

    for ((attempt=1; attempt<=max_attempts; attempt++)); do
        echo "A descarregar $output (tentativa $attempt/$max_attempts)..."

        rm -f "$tmp"

        if wget --timeout=90 -O "$tmp" "$url" &&
           python3 -c '
import json, sys
try:
    with open(sys.argv[1], encoding="utf-8") as f:
        data = json.load(f)
    if not isinstance(data, dict) or not isinstance(data.get("elements"), list):
        sys.exit(1)
except Exception:
    sys.exit(1)
' "$tmp"
        then
            mv -f "$tmp" "$output"
            echo "OK: $output atualizado."
            return 0
        fi

        rm -f "$tmp"

        if [ "$attempt" -lt "$max_attempts" ]; then
            echo "Falha no download de $output."
            echo "Nova tentativa em 30 segundos..."
            sleep 30
        fi
    done

    echo "AVISO: Falharam as $max_attempts tentativas de $output."
    echo "O ficheiro anterior foi preservado."
    return 1
}



echo "PCN"
download_json Type2s.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22socket%3Atype2_combo%22!~%22.*%22%5D%5B%22motorcar%22%3D%22yes%22%5D(area.searchArea)%3Bnode%5B%22man_made%22%3D%22charge_point%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22socket%3Atype2_combo%22!~%22.*%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D(area.searchArea)%3B)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

echo "PCR"
download_json PCR.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anode%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3C150)(area.searchArea)%3B%0Anode%5B%22man_made%22%3D%22charge_point%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3C150)(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

echo "PCUR1"
download_json PCSR.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anode%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3E149)(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3C350)(area.searchArea)%3B%0Anode%5B%22man_made%22%3D%22charge_point%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3E149)(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3C350)(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

echo "PCUR2"
download_json PCUR.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anode%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3E349)(area.searchArea)%3B%0Anode%5B%22man_made%22%3D%22charge_point%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B%22socket%3Atype2_combo%22~%22.*%22%5D%5B%22socket%3Atype2_combo%3Aoutput%22~kW%5D(if%3Anumber(t%5B%22socket%3Atype2_combo%3Aoutput%22%5D)%3E349)(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

#echo "SuC"
download_json SuC.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anode%5B%22amenity%22%3D%22charging_station%22%5D%5B~%22socket%3Atesla_supercharger%22~%22.*%22%5D(area.searchArea)%3B%0Anode%5B%22man_made%22%3D%22charge_point%22%5D%5B~%22socket%3Atesla_supercharger%22~%22.*%22%5D(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B'
#sleep 30

echo "inop"
download_json inop.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anode%5B%22disused%3Aamenity%22%3D%22charging_station%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D(area.searchArea)%3B%0Anode%5B%22disused%3Aman_made%22%3D%22charge_point%22%5D%5B%22motorcar%22%3D%22yes%22%5D(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

#echo "plan"
download_json plan.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22planned%3Aamenity%22%3D%22charging_station%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D(area.searchArea)%3Bnode%5B%22planned%3Aman_made%22%3D%22charge_point%22%5D%5B%22motorcar%22%3D%22yes%22%5D(area.searchArea)%3B)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B'
#sleep 30

echo "const"
download_json const.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22construction%3Aamenity%22%3D%22charging_station%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D(area.searchArea)%3Bnode%5B%22construction%3Aman_made%22%3D%22charge_point%22%5D%5B%22motorcar%22%3D%22yes%22%5D(area.searchArea)%3B)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B'
sleep 30

echo "Privados"
download_json Privados.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Anode%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22customers%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D(area.searchArea)%3B%0Anode%5B%22man_made%22%3D%22charge_point%22%5D%5B%22access%22%3D%22customers%22%5D%5B%22motorcar%22%3D%22yes%22%5D(area.searchArea)%3B%0A)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B%0A'
sleep 30

echo "NotAuto"
download_json NotAuto.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22access%22~%22%5E(yes%7Cpermissive)%24%22%5D%5B%22amenity%22%3D%22charging_station%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22socket%3Atesla_destination%22!~%22.%22%5D%5B%22socket%3Atype2%22!~%22.%22%5D%5B%22socket%3Achademo%22!~%22.%22%5D%5B%22socket%3Atype2_combo%22!~%22.%22%5D%5B%22socket%3Atype2_cable%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger_ccs%22!~%22.%22%5D(area.searchArea)%3Bnode%5B%22access%22~%22%5E(yes%7Cpermissive)%24%22%5D%5B%22man_made%22%3D%22charge_point%22%5D%5B%22socket%3Atesla_destination%22!~%22.%22%5D%5B%22socket%3Atype2%22!~%22.%22%5D%5B%22socket%3Achademo%22!~%22.%22%5D%5B%22socket%3Atype2_combo%22!~%22.%22%5D%5B%22socket%3Atype2_cable%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger%22!~%22.%22%5D%5B%22socket%3Atesla_supercharger_ccs%22!~%22.%22%5D(area.searchArea)%3B)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B'
sleep 30

echo "Areas"
download_json Areas.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Away%5B%22amenity%22%3D%22charging_station%22%5D%5B%22motorcar%22%3D%22yes%22%5D(area.searchArea)%3B%0A)%3Bout%20geom%3B%0A'
sleep 30

echo "TPA"
download_json TPA.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(node%5B%22amenity%22%3D%22charging_station%22%5D%5B%22access%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B%22payment%3Acards%22%3D%22yes%22%5D(area.searchArea)%3Bnode%5B%22man_made%22%3D%22charge_point%22%5D%5B%22access%22%3D%22yes%22%5D%5B%22motorcar%22%3D%22yes%22%5D%5B~%22socket%22~%22.*%22%5D%5B%22payment%3Acards%22%3D%22yes%22%5D(area.searchArea)%3B)%3Bout%20center%3B%3E%3Bout%20skel%20qt%3B'
sleep 30

echo "Parking_space"
download_json Parking_space.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A25%5D%3Barea(3600295480)-%3E.searchArea%3B(%0Away%5B%22amenity%22%3D%22parking_space%22%5D%5B%22parking_space%22%3D%22charging%22%5D(area.searchArea)%3B%0A)%3Bout%20geom%3B'
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
osmtogeojson TPA.json >| TPA.geojson
osmtogeojson Parking_space.json >| Parking_space.geojson

echo "Todos"
download_json Todos.json 'https://overpass-api.de/api/interpreter?data=%5Bout%3Ajson%5D%5Btimeout%3A60%5D%3B%0Aarea(id%3A3600295480)-%3E.searchArea%3B%0A(%0Anwr%5B%22construction%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B%0Anwr%5B%22amenity%22%3D%22charging_station%22%5D(area.searchArea)%3B%0Anwr%5B%22disused%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B%0Anwr%5B%22removed%3Aamenity%22%3D%22charging_station%22%5D(area.searchArea)%3B%0Anwr%5B%22man_made%22%3D%22charge_point%22%5D(area.searchArea)%3B%0Anwr%5B%22construction%3Aman_made%22%3D%22charge_point%22%5D(area.searchArea)%3B%0Anwr%5B%22disused%3Aman_made%22%3D%22charge_point%22%5D(area.searchArea)%3B%0Anwr%5B%22removed%3Aman_made%22%3D%22charge_point%22%5D(area.searchArea)%3B%0A)%3B%0Aout%20body%3B%0A%3E%3B%0Aout%20skel%20qt%3B'
sleep 30

osmtogeojson Todos.json >| Todos.geojson
