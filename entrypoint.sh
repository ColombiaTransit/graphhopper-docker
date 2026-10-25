#!/usr/bin/env bash
# Downloadt de OSM-export en bouwt de graaf als die er nog niet is (of FORCE_IMPORT=true),
# en start daarna de server.
set -euo pipefail
cd /graphhopper
PBF=/data/colombia-latest.osm.pbf
GRAPH=/data/graph-cache

if [ "${FORCE_IMPORT}" = "true" ] || [ ! -f "$GRAPH/properties" ]; then
  echo "== GraphHopper ${GH_VERSION}: OSM-data downloaden: ${PBF_URL}"
  wget -q -O "$PBF.tmp" "${PBF_URL}"
  mv -f "$PBF.tmp" "$PBF"
  echo "== Graaf bouwen (kan een tijd duren)"
  # In een tijdelijke map bouwen en daarna omwisselen: nooit over een werkende graaf heen.
  rm -rf "$GRAPH.new"
  java ${JAVA_OPTS} -Ddw.graphhopper.datareader.file="$PBF" -Ddw.graphhopper.graph.location="$GRAPH.new" \
    -jar graphhopper-web.jar import config-colombia.yml
  rm -rf "$GRAPH.old"
  [ -d "$GRAPH" ] && mv "$GRAPH" "$GRAPH.old"
  mv "$GRAPH.new" "$GRAPH"
  rm -rf "$GRAPH.old"
  echo "== Graaf klaar"
fi

echo "== GraphHopper ${GH_VERSION} starten op poort 8989"
exec java ${JAVA_OPTS} -Ddw.graphhopper.datareader.file="$PBF" -Ddw.graphhopper.graph.location="$GRAPH" \
  -jar graphhopper-web.jar server config-colombia.yml
