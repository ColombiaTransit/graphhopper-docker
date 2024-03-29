FROM eclipse-temurin:21
RUN mkdir -p /srv/graphhopper

ADD https://repo1.maven.org/maven2/com/graphhopper/graphhopper-web/8.0/graphhopper-web-8.0.jar /srv/graphhopper
ADD http://download.geofabrik.de/south-america/colombia-latest.osm.pbf /srv/graphhopper

RUN cd /srv/graphhopper

COPY config-colombia.yml ./

RUN sed -i '/^ *bind_host/s/^ */&# /p' config-colombia.yml

EXPOSE 8989

HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:8989/health || exit 1

CMD ["java", "-Xmx3G", "-jar", "/srv/graphhopper/graphhopper-web-8.0.jar", "server", "config-colombia.yml"]
