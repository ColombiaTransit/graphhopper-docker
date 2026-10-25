# GraphHopper (routeplanner) voor Colombia, met de Geofabrik-export.
#
# OSM-data en graaf zitten NIET in het image: bij de eerste start downloadt de container de
# Colombia-export van Geofabrik en bouwt de graaf in /data (een volume). Daarna start hij
# direct. Nieuwe OSM-data: FORCE_IMPORT=true (bouwt in een tijdelijke map en wisselt dan om).
FROM eclipse-temurin:21-jre

ARG GH_VERSION=11.1
ENV GH_VERSION=${GH_VERSION}

RUN apt-get update \
 && apt-get install -y --no-install-recommends wget ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /graphhopper /data \
 && wget -q -O /graphhopper/graphhopper-web.jar \
      "https://github.com/graphhopper/graphhopper/releases/download/${GH_VERSION}/graphhopper-web-${GH_VERSION}.jar"

COPY config-colombia.yml /graphhopper/config-colombia.yml
COPY entrypoint.sh /graphhopper/entrypoint.sh
RUN chmod +x /graphhopper/entrypoint.sh

WORKDIR /graphhopper
VOLUME ["/data"]
EXPOSE 8989

ENV JAVA_OPTS="-Xmx6G" \
    PBF_URL="https://download.geofabrik.de/south-america/colombia-latest.osm.pbf" \
    FORCE_IMPORT="false"

HEALTHCHECK --interval=60s --timeout=10s --start-period=60m --retries=3 \
  CMD wget -q -O /dev/null "http://127.0.0.1:8989/health" || exit 1

ENTRYPOINT ["/graphhopper/entrypoint.sh"]
