# Admin UIs and logs

[中文](../VIEW_UI_LOGS.md)

Replace `<your-ip>` with the bind IP from `.env`. Credentials are in `.env`.

| UI | URL | Login |
|----|-----|--------|
| phpMyAdmin | `http://<your-ip>:${MYSQL_UI_PORT}` | `root` / `MYSQL_ROOT_PASSWORD`; server host `mysql` |
| pgAdmin | `http://<your-ip>:${POSTGRESQL_UI_PORT}` | `POSTGRESQL_UI_USERNAME` / `POSTGRESQL_UI_PASSWORD` |
| mongo-express | `http://<your-ip>:${MONGO_UI_PORT}` | `MONGO_UI_*` then Mongo root |
| RedisInsight | `http://<your-ip>:${REDIS_UI_PORT}` | `redis:6379`, `REDIS_PASSWORD` |
| Kafka UI | `http://<your-ip>:${KAFKA_UI_PORT}` | cluster `nfx_stack_public`, `kafka:9092` |
| RabbitMQ | `http://<your-ip>:${RABBITMQ_UI_PORT}` | `RABBITMQ_DEFAULT_USER` / `RABBITMQ_DEFAULT_PASS` |
| MinIO Console | `http://<your-ip>:${MINIO_UI_PORT}` | `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD` |
| Centrifugo Admin | `http://<your-ip>:${CENTRIFUGO_PORT}` | `Infrastructure/config/centrifugo.json` `admin` |
| Jaeger | `http://<your-ip>:${OTEL_JAEGER_UI_PORT}` | none |
| Prometheus | `http://<your-ip>:${OTEL_PROMETHEUS_PORT}` | none |
| Grafana | `http://<your-ip>:${OTEL_GRAFANA_PORT}` | `GRAFANA_ADMIN_USER` / `GRAFANA_ADMIN_PASSWORD` |
| OpenSearch Dashboards | `http://<your-ip>:${OPENSEARCH_DASHBOARDS_PORT}` | `admin` / `OPENSEARCH_PASSWORD` |

Collector health: `http://<your-ip>:${OTEL_COLLECTOR_HEALTH_PORT}`.

```bash
./start.sh logs
docker logs -f NFX-Stack-MySQL
```
