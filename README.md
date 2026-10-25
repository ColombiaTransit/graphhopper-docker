# graphhopper-docker

Docker-image voor [GraphHopper](https://github.com/graphhopper/graphhopper) met de
[Geofabrik-export van Colombia](https://download.geofabrik.de/south-america/colombia.html).
Wordt gebruikt om gereconstrueerde busritten (gtfs-redbus) te valideren: route, afstand en
reistijd tussen opeenvolgende haltes.

- GraphHopper **11.0** (Java 21). Andere versie: build-argument `GH_VERSION`.
- Profielen `car` en `bus` (custom model `bus.json` van GraphHopper), beide met Contraction
  Hierarchies.
- OSM-data en graaf staan in het volume `/data`, niet in het image. Bij de eerste start wordt
  de export gedownload (`PBF_URL`) en de graaf gebouwd; daarna start de server direct.
  Nieuwe data: `FORCE_IMPORT=true` (bouwt in een tijdelijke map en wisselt dan om).

```bash
docker compose up -d
docker compose logs -f graphhopper      # wachten op "GraphHopper 11.0 starten"
curl "http://localhost:8989/route?profile=bus&point=8.7509,-75.8787&point=10.4236,-75.5253&points_encoded=false"
```

Via Traefik (`api-graphhopper.yml`): `https://apiv2.colombiatransit.co/api/graphhopper/route?...`

Geheugen: `JAVA_OPTS=-Xmx6G` is ruim voor Colombia met twee CH-profielen.
