# NFX Stack configuration

[中文](../CONFIGURATION.md)

All settings live in the repo-root `.env`:

```bash
cp .example.env .env
```

`./start.sh` interpolates that file. Some services also receive values via compose `environment:`.

## Bind addresses

`*_HOST` is the host bind address: `0.0.0.0`, `127.0.0.1`, or a LAN IP such as `192.168.1.64`.

## Port variables

| Variable | Role |
|----------|------|
| `MYSQL_DATABASE_PORT` / `MYSQL_UI_PORT` | MySQL / phpMyAdmin |
| `MONGO_DATABASE_PORT` / `MONGO_UI_PORT` | MongoDB / mongo-express |
| `POSTGRESQL_DATABASE_PORT` / `POSTGRESQL_UI_PORT` | PostgreSQL / pgAdmin |
| `REDIS_DATABASE_PORT` / `REDIS_UI_PORT` | Redis / RedisInsight |
| `KAFKA_EXTERNAL_PORT` / `KAFKA_UI_PORT` | Kafka EXTERNAL / UI |
| `RABBITMQ_AMQP_PORT` / `RABBITMQ_UI_PORT` | AMQP / Management |
| `MINIO_API_PORT` / `MINIO_UI_PORT` | S3 / Console |
| `CENTRIFUGO_PORT` | WS / SSE / Admin |
| `OTEL_JAEGER_UI_PORT` | Jaeger |
| `OTEL_COLLECTOR_OTLP_GRPC_PORT` / `OTEL_COLLECTOR_OTLP_HTTP_PORT` | OTLP |
| `OTEL_GRAFANA_PORT` / `OTEL_PROMETHEUS_PORT` / `OTEL_LOKI_PORT` | Grafana / Prometheus / Loki |
| `OPENSEARCH_EXTERNAL_PORT` / `OPENSEARCH_DASHBOARDS_PORT` | REST HTTPS / Dashboards |

Kafka advertised EXTERNAL listener uses `KAFKA_INTERNAL_HOST_IP` + `KAFKA_EXTERNAL_PORT`.

## In-network endpoints

| Service | Address |
|---------|--------|
| MySQL | `mysql:3306` |
| PostgreSQL | `postgresql:5432` |
| MongoDB | `mongodb:27017` (`authSource=admin`) |
| Redis | `redis:6379` |
| Kafka | `kafka:9092` |
| RabbitMQ | `rabbitmq:5672` |
| MinIO | `http://minio:9000` (path-style) |
| Centrifugo API | `http://centrifugo:8000/api` |
| OTLP | `otel-collector:4317` |
| OpenSearch | `https://opensearch:9200` |

From the host, use the bind IP and mapped ports from `.env`.

## Data paths

`MYSQL_DATA_PATH`, `POSTGRESQL_DATA_PATH`, `MINIO_DATA_PATH`, `PROMETHEUS_DATA_PATH`, `LOKI_DATA_PATH`, `GRAFANA_DATA_PATH`, `OPENSEARCH_DATA_PATH`, and the other `*_DATA_PATH` / `*_LOG_PATH` variables.

`CENTRIFUGO_API_KEY` / `CENTRIFUGO_CLIENT_SECRET` must match `Infrastructure/config/centrifugo.json`.  
`OPENSEARCH_PASSWORD` is the admin password. It must pass zxcvbn (`Lucas127.` is rejected as weak).
