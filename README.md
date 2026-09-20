# NFX Stack

> 部署、网络、配置与安全的详细说明见 [NFX-Documentation](https://github.com/NebulaForgeX/NFX-Documentation)（[第三章：NFX-Stack](https://github.com/NebulaForgeX/NFX-Documentation/blob/New-Arch/books/zh/chapter-03-nfx-stack-deployment.md)）。
> Deploy, network, config, and security: [NFX-Documentation](https://github.com/NebulaForgeX/NFX-Documentation) ([Chapter 3: NFX-Stack](https://github.com/NebulaForgeX/NFX-Documentation/blob/New-Arch/books/en/chapter-03-nfx-stack-deployment.md)).

**NFX Stack = NebulaForgeX Resource Stack**

统一资源与基础设施平台。所有服务拆在 `Infrastructure/`，用根目录 `./start.sh` + `.env` 启动。

<div align="center">
  <img src="image.png" alt="NFX Stack Logo" width="200">
</div>

## 快速开始

```bash
cp .example.env .env
# 填写密码、绑定 IP、端口、数据路径

./start.sh          # up -d 全部栈
./start.sh ps
./start.sh down
```

默认网络 `nfx-stack`。业务容器加入该网络后用容器名访问（如 `mysql:3306`）。

## 服务（镜像已钉版本）

| 栈 | Compose | 容器 | 镜像 |
|----|---------|------|------|
| MySQL | `docker-compose.mysql.yml` | `NFX-Stack-MySQL` / UI | `mysql:9.7.2` / `phpmyadmin:5.2.3` |
| MongoDB | `docker-compose.mongodb.yml` | `NFX-Stack-MongoDB` / UI | `mongo:4.4`（无 AVX 勿升 5.0+） |
| PostgreSQL | `docker-compose.postgresql.yml` | `NFX-Stack-PostgreSQL` / UI | `postgres:18.6` / `pgadmin4:9.17` |
| Redis | `docker-compose.redis.yml` | `NFX-Stack-Redis` / UI | `redis:8.8.2` / `redisinsight:3.8.0` |
| Kafka | `docker-compose.kafka.yml` | `NFX-Stack-Kafka` / UI | `apache/kafka:4.3.1` |
| RabbitMQ | `docker-compose.rabbitmq.yml` | `NFX-Stack-RabbitMQ` | `rabbitmq:4.3.5-management` |
| MinIO Community | `docker-compose.minio.yml` | `NFX-Stack-MinIO` | `quay.io/minio/minio:RELEASE.2025-09-07T16-13-09Z` |
| Centrifugo | `docker-compose.centrifugo.yml` | `NFX-Stack-Centrifugo` | `v6.9.4` |
| OTEL | `docker-compose.otel.yml` | Collector / Jaeger / Prometheus / Loki / Grafana | 见 Documentation 第三章 |
| OpenSearch | `docker-compose.opensearch.yml` | OpenSearch / Dashboards | `3.8.0` |

端口以 `.env` 为准。NAS 部署示例见 [第三章：NFX-Stack](https://github.com/NebulaForgeX/NFX-Documentation/blob/New-Arch/books/zh/chapter-03-nfx-stack-deployment.md)。

## 管理 UI

| UI | URL |
|----|-----|
| phpMyAdmin | `http://<ip>:${MYSQL_UI_PORT}` |
| pgAdmin | `http://<ip>:${POSTGRESQL_UI_PORT}` |
| Grafana | `http://<ip>:${OTEL_GRAFANA_PORT}` |
| MinIO Console | `http://<ip>:${MINIO_UI_PORT}` |

## 容器内连接

```
mysql://root:${MYSQL_ROOT_PASSWORD}@mysql:3306/
postgresql://${POSTGRESQL_ROOT_USERNAME}:${POSTGRESQL_ROOT_PASSWORD}@postgresql:5432/
mongodb://${MONGO_ROOT_USERNAME}:${MONGO_ROOT_PASSWORD}@mongodb:27017/?authSource=admin
redis://:${REDIS_PASSWORD}@redis:6379/0
kafka:9092
http://minio:9000          # path-style
http://centrifugo:8000/api
otel-collector:4317
https://opensearch:9200
```

MinIO 客户端必须 path-style。HTTP/HTTPS 入口在 **NFX-Edge**，本仓库不跑 Traefik。

**开发者**：Lucas Lyu · lyulucas2003@gmail.com
