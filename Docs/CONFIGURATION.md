# NFX Stack 配置详解

[English Version](en/CONFIGURATION.md)

配置全部在仓库根目录 `.env`。复制模板：

```bash
cp .example.env .env
```

`./start.sh` 用 `--env-file .env` 做变量插值；部分服务再通过 compose 的 `environment` 注入容器。

## 绑定 IP

`*_HOST` 是宿主机端口绑定地址：

- `0.0.0.0`：所有网卡
- `127.0.0.1`：仅本机
- `192.168.1.64`：指定 LAN IP（当前 NAS 用法）

## 端口变量

| 变量 | 用途 |
|------|------|
| `MYSQL_DATABASE_PORT` / `MYSQL_UI_PORT` | MySQL / phpMyAdmin |
| `MONGO_DATABASE_PORT` / `MONGO_UI_PORT` | MongoDB / mongo-express |
| `POSTGRESQL_DATABASE_PORT` / `POSTGRESQL_UI_PORT` | PostgreSQL / pgAdmin |
| `REDIS_DATABASE_PORT` / `REDIS_UI_PORT` | Redis / RedisInsight |
| `KAFKA_EXTERNAL_PORT` / `KAFKA_UI_PORT` | Kafka EXTERNAL / Kafka UI |
| `RABBITMQ_AMQP_PORT` / `RABBITMQ_UI_PORT` | AMQP / Management |
| `MINIO_API_PORT` / `MINIO_UI_PORT` | S3 API / Console |
| `CENTRIFUGO_PORT` | WS / SSE / Admin |
| `OTEL_JAEGER_UI_PORT` | Jaeger UI |
| `OTEL_COLLECTOR_OTLP_GRPC_PORT` / `OTEL_COLLECTOR_OTLP_HTTP_PORT` | 应用上报 OTLP |
| `OTEL_COLLECTOR_HEALTH_PORT` | Collector 健康检查 |
| `OTEL_COLLECTOR_PROMETHEUS_PORT` | Collector metrics `:8889` 映射 |
| `OTEL_PROMETHEUS_PORT` / `OTEL_LOKI_PORT` / `OTEL_GRAFANA_PORT` | Prometheus / Loki / Grafana |
| `OPENSEARCH_EXTERNAL_PORT` / `OPENSEARCH_DASHBOARDS_PORT` | REST HTTPS / Dashboards HTTP |

`KAFKA_ADVERTISED_LISTENERS` 使用 `KAFKA_INTERNAL_HOST_IP` + `KAFKA_EXTERNAL_PORT`，外部客户端必须能解析到该 IP。

## 应用侧连接

容器内（同 `nfx-stack` 网）：

| 服务 | 地址 |
|------|------|
| MySQL | `mysql:3306` |
| PostgreSQL | `postgresql:5432` |
| MongoDB | `mongodb:27017`（`authSource=admin`） |
| Redis | `redis:6379` |
| Kafka | `kafka:9092` |
| RabbitMQ | `rabbitmq:5672` |
| MinIO | `http://minio:9000`（path-style） |
| Centrifugo API | `http://centrifugo:8000/api` |
| OTLP | `otel-collector:4317`（`OTEL_EXPORTER_OTLP_INSECURE=true`） |
| OpenSearch | `https://opensearch:9200`（自签证书，开发可关 TLS 校验） |

宿主机把主机名换成 `.env` 里的绑定 IP 和外部端口。

## 数据路径

| 变量 | 默认用途 |
|------|------|
| `MYSQL_DATA_PATH` / `MYSQL_INIT_PATH` / `MYSQL_LOG_PATH` | MySQL 数据 / init / 日志 |
| `MONGO_*` / `POSTGRESQL_*` / `REDIS_*` / `KAFKA_*` / `RABBITMQ_*` | 对应引擎 |
| `MINIO_DATA_PATH` | 对象存储（`Stores/`） |
| `PROMETHEUS_DATA_PATH` / `LOKI_DATA_PATH` / `GRAFANA_DATA_PATH` | 观测数据 |
| `OPENSEARCH_DATA_PATH` | OpenSearch 索引 |

Windows 请改成盘符路径，例如 `D:/Code/NFX-Stack/Databases/mysql`。

## Centrifugo / Grafana / OpenSearch

- `CENTRIFUGO_API_KEY`、`CENTRIFUGO_CLIENT_SECRET` 必须与 `Infrastructure/config/centrifugo.json` 一致
- `GRAFANA_ADMIN_USER` / `GRAFANA_ADMIN_PASSWORD` 登录 Grafana
- `OPENSEARCH_PASSWORD` 即 admin 密码，须通过 zxcvbn（`Lucas127.` 会被判弱密码）
- `OPENSEARCH_JAVA_OPTS` 控制堆，NAS 默认 `-Xms512m -Xmx512m`
