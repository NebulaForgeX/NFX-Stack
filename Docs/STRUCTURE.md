# NFX Stack 项目结构

[English Version](en/STRUCTURE.md)

所有服务拆在 `Infrastructure/docker-compose.<name>.yml`，模板为同名 `docker-compose.example.<name>.yml`。根目录用 `./start.sh` 读取 `.env` 后按序启动（跳过 `*.example.*`）。

## 目录结构

```
NFX-Stack/
├── .env                          # 本机配置（从 .example.env 复制，勿提交）
├── .example.env                   # 环境变量模板
├── start.sh                      # 一键启动 / 停止 Infrastructure
├── version.sh                    # 镜像版本检查
├── README.md
├── Infrastructure/
│   ├── docker-compose.<name>.yml
│   ├── docker-compose.example.<name>.yml
│   └── config/                   # Centrifugo / OTEL / Grafana / OpenSearch
├── Databases/                    # 数据卷（mysql、postgresql、mongodb、redis、kafka、rabbitmq、minio、prometheus、loki、grafana、opensearch）
├── Logs/
└── Docs/
```

## 编排文件

| 文件 | 服务 | 镜像 |
|------|------|------|
| `docker-compose.mysql.yml` | mysql、mysql-ui | `mysql:9.7.2`、`phpmyadmin:5.2.3` |
| `docker-compose.mongodb.yml` | mongodb、mongodb-ui | `mongo:4.4`、`mongo-express:1.0.2-20-alpine3.19` |
| `docker-compose.postgresql.yml` | postgresql、postgresql-ui | `postgres:18.6`、`dpage/pgadmin4:9.17` |
| `docker-compose.redis.yml` | redis、redis-ui | `redis:8.8.2`、`redis/redisinsight:3.8.0` |
| `docker-compose.kafka.yml` | kafka、kafka-ui | `apache/kafka:4.3.1`、`provectuslabs/kafka-ui:v0.7.2` |
| `docker-compose.rabbitmq.yml` | rabbitmq | `rabbitmq:4.3.5-management` |
| `docker-compose.minio.yml` | minio | `quay.io/minio/aistor/minio:latest` |
| `docker-compose.centrifugo.yml` | centrifugo | `centrifugo/centrifugo:v6.9.4` |
| `docker-compose.otel.yml` | otel-collector、jaeger、prometheus、loki、grafana | Collector `0.160.0`、Jaeger `2.20.0`、Prometheus `v3.14.0`、Loki `3.7.7`、Grafana `13.2.1` |
| `docker-compose.opensearch.yml` | opensearch、opensearch-dashboards | `3.8.0` |

MongoDB 固定 `4.4`：MongoDB 5.0+ 需要 AVX，Asustor NAS 无 AVX。

## 网络

- 名称：`nfx-stack`（`start.sh` 若不存在会创建）
- 各 compose 以 `external: true` 挂入，不随单个栈 `down` 删除
- 业务容器加入该网络后可用容器名：`mysql:3306`、`postgresql:5432`、`mongodb:27017`、`redis:6379`、`kafka:9092`、`minio:9000`、`centrifugo:8000`、`otel-collector:4317`、`opensearch:9200`

## 边缘路由

HTTP/HTTPS 入口在 **NFX-Edge**（`NFX-Edge-Reverse-Proxy`），不在本仓库。Stack 只提供数据和中间件。


## 数据持久化

路径由 `.env` 的 `*_DATA_PATH` 指定，默认在仓库 `Databases/`、`Logs/`。
