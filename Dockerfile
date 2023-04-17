FROM eclipse-temurin:11
RUN mkdir -p /srv/graphhopper

ADD https://repo1.maven.org/maven2/com/graphhopper/graphhopper-web/7.0/graphhopper-web-7.0.jar /srv/graphhopper

# ADD https://download1.graphhopper.com/public/extracts/by-country-code/co/photon-db-co-latest.tar.bz2 /srv/photon

RUN cd /srv/graphhopper

RUN wget -O - http://download.geofabrik.de/south-america/colombia-latest.osm.pbf

EXPOSE 2322
CMD ["java", "-Xmx8G", "-jar", "graphhopper*.jar", "server", "config-colombia.yml"" ]
