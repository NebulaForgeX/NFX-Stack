# 管理 UI 与日志

[English Version](en/VIEW_UI_LOGS.md)

把 `<your-ip>` 换成 `.env` 里的绑定 IP。账号密码也在 `.env`。

| UI | URL | 登录 |
|----|-----|------|
| phpMyAdmin | `http://<your-ip>:${MYSQL_UI_PORT}` | MySQL `root` / `MYSQL_ROOT_PASSWORD`；服务器填 `mysql` |
| pgAdmin | `http://<your-ip>:${POSTGRESQL_UI_PORT}` | `POSTGRESQL_UI_USERNAME` / `POSTGRESQL_UI_PASSWORD` |
| mongo-express | `http://<your-ip>:${MONGO_UI_PORT}` | Basic Auth：`MONGO_UI_*`，再连 Mongo root |
| RedisInsight | `http://<your-ip>:${REDIS_UI_PORT}` | 连接 `redis:6379` 或宿主机 Redis 端口，密码 `REDIS_PASSWORD` |
| Kafka UI | `http://<your-ip>:${KAFKA_UI_PORT}` | 集群 `nfx_stack_public`，`kafka:9092` |
| RabbitMQ | `http://<your-ip>:${RABBITMQ_UI_PORT}` | `RABBITMQ_DEFAULT_USER` / `RABBITMQ_DEFAULT_PASS` |
| MinIO Console | `http://<your-ip>:${MINIO_UI_PORT}` | `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD` |
| Centrifugo Admin | `http://<your-ip>:${CENTRIFUGO_PORT}` | 见 `Infrastructure/config/centrifugo.json` 的 `admin` |
| Jaeger | `http://<your-ip>:${OTEL_JAEGER_UI_PORT}` | 无 |
| Prometheus | `http://<your-ip>:${OTEL_PROMETHEUS_PORT}` | 无 |
| Grafana | `http://<your-ip>:${OTEL_GRAFANA_PORT}` | `GRAFANA_ADMIN_USER` / `GRAFANA_ADMIN_PASSWORD` |
| OpenSearch Dashboards | `http://<your-ip>:${OPENSEARCH_DASHBOARDS_PORT}` | `admin` / `OPENSEARCH_PASSWORD` |

Collector 健康检查：`http://<your-ip>:${OTEL_COLLECTOR_HEALTH_PORT}`。

## 日志

```bash
./start.sh logs
docker logs -f NFX-Stack-MySQL
docker logs NFX-Stack-Otel-Collector
```

容器 stdout 由 json-file 驱动限制（多数栈 `10m × 10`；Kafka `50m × 10`）。
