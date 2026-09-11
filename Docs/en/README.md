# Connecting apps to NFX Stack

[中文](../README.md)

Ports and credentials come from the repo-root `.env`. Join the `nfx-stack` network and use container names; from the host or LAN use `*_HOST` + `*_PORT`.

## Inside Docker

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

Frontends should use `CENTRIFUGO_PUBLIC_WS_URL` / `CENTRIFUGO_PUBLIC_SSE_URL`.

## MinIO

Image is **MinIO AIStor** (`quay.io/minio/aistor/minio:latest`). Clients must use path-style. A Free/SUBNET license can be mounted for production (see compose comments).

HTTP/HTTPS edge routing is **NFX-Edge**. Do not run Traefik inside this stack.

