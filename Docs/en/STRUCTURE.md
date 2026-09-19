# NFX Stack project structure

[中文](../STRUCTURE.md)

Every service lives in `Infrastructure/docker-compose.<name>.yml`. Templates are `docker-compose.example.<name>.yml`. `./start.sh` reads the root `.env` and starts the real files in order (skips `*.example.*`).

## Layout

```
NFX-Stack/
├── .env
├── .example.env
├── start.sh
├── version.sh
├── README.md
├── Infrastructure/
│   ├── docker-compose.<name>.yml
│   ├── docker-compose.example.<name>.yml
│   └── config/
├── Databases/
├── Logs/
└── Docs/
```

## Compose files

| File | Services | Images |
|------|---------|--------|
| `docker-compose.mysql.yml` | mysql, mysql-ui | `mysql:9.7.2`, `phpmyadmin:5.2.3` |
| `docker-compose.mongodb.yml` | mongodb, mongodb-ui | `mongo:4.4`, `mongo-express:1.0.2-20-alpine3.19` |
| `docker-compose.postgresql.yml` | postgresql, postgresql-ui | `postgres:18.6`, `dpage/pgadmin4:9.17` |
| `docker-compose.redis.yml` | redis, redis-ui | `redis:8.8.2`, `redis/redisinsight:3.8.0` |
| `docker-compose.kafka.yml` | kafka, kafka-ui | `apache/kafka:4.3.1`, `provectuslabs/kafka-ui:v0.7.2` |
| `docker-compose.rabbitmq.yml` | rabbitmq | `rabbitmq:4.3.5-management` |
| `docker-compose.minio.yml` | minio | `quay.io/minio/minio:RELEASE.2025-09-07T16-13-09Z` |
| `docker-compose.centrifugo.yml` | centrifugo | `centrifugo/centrifugo:v6.9.4` |
| `docker-compose.otel.yml` | collector, jaeger, prometheus, loki, grafana | `0.160.0` / `2.20.0` / `v3.14.0` / `3.7.7` / `13.2.1` |
| `docker-compose.opensearch.yml` | opensearch, dashboards | `3.8.0` |

MongoDB stays on `4.4` because 5.0+ needs AVX (this NAS has none).

## Network

Name: `nfx-stack`. `start.sh` creates it if missing. Compose files attach with `external: true`.

App containers on that network can use `mysql:3306`, `postgresql:5432`, `mongodb:27017`, `redis:6379`, `kafka:9092`, `minio:9000`, `centrifugo:8000`, `otel-collector:4317`, `opensearch:9200`.

HTTP/HTTPS edge routing lives in **NFX-Edge**, not this repo.

Data paths come from `*_DATA_PATH` in `.env`. Defaults live under `Databases/` and `Logs/`.

