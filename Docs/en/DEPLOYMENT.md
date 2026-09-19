# NFX Stack deployment

[中文](../DEPLOYMENT.md)

## Prerequisites

- Docker 20.10+, Compose v2
- ≥ 10GB disk; ≥ 4GB RAM recommended (OpenSearch / OTEL need more)
- Do not upgrade MongoDB past 4.4 on CPUs without AVX

## Quick deploy

```bash
cd /path/to/NFX-Stack
cp .example.env .env
# edit passwords, bind IPs, ports, data paths

./start.sh          # create nfx-stack network and up -d
./start.sh ps
./start.sh logs
./start.sh down     # stop containers; bind-mounted data stays
```

One stack only:

```bash
docker compose --project-directory Infrastructure --env-file .env \
  -f Infrastructure/docker-compose.mysql.yml up -d
```

## Ports (see `.env`)

Example LAN bind `192.168.1.64`:

| Service | Data/API | UI |
|---------|----------|-----|
| MySQL | 10100 | 10101 |
| MongoDB | 10102 | 10103 |
| PostgreSQL | 10104 | 10105 |
| Redis | 10106 | 10107 |
| Kafka | 10108 | 10109 |
| RabbitMQ | 10110 | 10111 |
| MinIO | 10112 | 10113 |
| Centrifugo | 10114 | admin on same port |
| Jaeger / OTLP gRPC / HTTP | 10115 / 10116 / 10117 | health 10118 |
| Prometheus / Loki / Grafana | 10120 / 10121 / 10122 | exporter 10119 |
| OpenSearch | 10123 HTTPS | 10124 Dashboards HTTP |

Restrict these ports to trusted networks.

## Maintenance

```bash
./version.sh
./start.sh down && ./start.sh    # after .env port/password changes
```

`OPENSEARCH_PASSWORD` applies only on first data-dir init. To rotate it, wipe `OPENSEARCH_DATA_PATH` and start again.

## Troubleshooting

- Missing network: `./start.sh` creates it
- Port in use: change the matching `*_PORT` in `.env`
- Mongo will not start: keep `mongo:4.4`
- OpenSearch: password must pass zxcvbn; data dir must be writable by uid 1000 (`./start.sh` chowns it); heap via `OPENSEARCH_JAVA_OPTS`
- Grafana / Prometheus / Loki stuck Restarting: bind dirs created as `root:root` by `sudo docker` are not writable by the image user. `./start.sh` chowns them to 472 / 65534 / 10001
- MinIO will not start / data dir errors: after switching from AIStor, wipe `MINIO_DATA_PATH` if the on-disk format is incompatible, then `./start.sh`
