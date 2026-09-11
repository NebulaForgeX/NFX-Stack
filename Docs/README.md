# NFX Stack 业务接入

[English Version](en/README.md)

凭证和端口一律以仓库根目录 `.env` 为准。把业务容器加入网络 `nfx-stack` 后用容器名；在宿主机或 LAN 用 `.env` 的 `*_HOST` + `*_PORT`。

## 容器内

```toml
[mysql]
host = "mysql"
port = 3306

[postgresql]
host = "postgresql"
port = 5432

[mongodb]
host = "mongodb"
port = 27017

[cache]
host = "redis"
port = 6379

[kafka]
brokers = ["kafka:9092"]

[minio]
endpoint = "http://minio:9000"
access_key = "<MINIO_ROOT_USER>"
secret_key = "<MINIO_ROOT_PASSWORD>"
secure = false
# AWS SDK: forcePathStyle = true

[centrifugo]
api_url = "http://centrifugo:8000/api"
api_key = "<CENTRIFUGO_API_KEY>"

[otel]
endpoint = "otel-collector:4317"
insecure = true

[opensearch]
host = "opensearch"
port = 9200
scheme = "https"
username = "admin"
tls_verify = false
```

## 宿主机 / LAN

把 host 换成 `.env` 绑定 IP，端口换成外部映射，例如 MySQL `${MYSQL_DATABASE_PORT}`、MinIO `${MINIO_API_PORT}`、Centrifugo `${CENTRIFUGO_PORT}`、OTLP `${OTEL_COLLECTOR_OTLP_GRPC_PORT}`、OpenSearch `${OPENSEARCH_EXTERNAL_PORT}`。

前端 WebSocket / SSE 用 `CENTRIFUGO_PUBLIC_WS_URL` / `CENTRIFUGO_PUBLIC_SSE_URL`。

## 占位符

| 占位符 | `.env` |
|--------|--------|
| MySQL root 密码 | `MYSQL_ROOT_PASSWORD` |
| PostgreSQL 密码 | `POSTGRESQL_ROOT_PASSWORD` |
| Redis 密码 | `REDIS_PASSWORD` |
| Mongo 用户/密码 | `MONGO_ROOT_USERNAME` / `MONGO_ROOT_PASSWORD` |
| MinIO | `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD` |
| Centrifugo | `CENTRIFUGO_API_KEY` / `CENTRIFUGO_CLIENT_SECRET` |
| OpenSearch admin | `OPENSEARCH_PASSWORD` |

库名、Kafka topic、MinIO bucket 由各产品自己定。

## MinIO

当前镜像是 **MinIO AIStor**（`quay.io/minio/aistor/minio:latest`）。客户端必须 path-style。生产可挂 Free/SUBNET 许可证（见 compose 注释）。

HTTP/HTTPS 边缘路由使用 **NFX-Edge**，不要在 Stack 里再起 Traefik。
