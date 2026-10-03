# NFX-Stack

[English](README.en.md)

<div align="center">
  <img src="image.png" alt="NFX-Stack" width="200">
</div>

NebulaForgeX 的数据面。Identity、Edge、News、Storages 的 Postgres、Redis、Kafka、MinIO、OTLP 都连这里，不要在那些仓里再起一套。产品通过局域网 `NAS_IP:宿主机端口` 连接，**不**加入共享 Docker 网络。同一份 compose 里的进程（例如 Kafka UI → `kafka:9092`）才用服务名。

本仓 **不**跑 Traefik。HTTP/HTTPS 入口是 [NFX-Edge](https://github.com/NebulaForgeX/NFX-Edge)，只占主机 80/443。这些端口只给受信 LAN，绑定 `.env` 里的局域网 IP（例如 `192.168.1.64`），不要对公网开 `0.0.0.0`。

## 宿主机端口

从 **10000** 起连续排列，**10025–10029** 预留。产品客户端默认连加粗的那几个。

| 服务 | 数据 / API | UI |
|------|------------|-----|
| MySQL | **10000** | 10001 phpMyAdmin |
| MongoDB | 10002 | 10003 mongo-express |
| PostgreSQL | **10004** | 10005 pgAdmin |
| Redis | **10006** | 10007 RedisInsight |
| Kafka EXTERNAL | **10008** | 10009 Kafka UI |
| RabbitMQ AMQP | 10010 | 10011 Management |
| MinIO S3 | **10012** | 10013 Console（必须 path-style） |
| Centrifugo | 10014 | 同端口 Admin |
| Jaeger | — | 10015 |
| OTLP gRPC / HTTP | **10016** / 10017 | Collector health 10018 |
| Collector Prometheus / Prometheus / Loki | 10019 / 10020 / 10021 | Grafana 10022 |
| OpenSearch | 10023 HTTPS | 10024 Dashboards HTTP |

`KAFKA_ADVERTISED_LISTENERS` 用 `KAFKA_INTERNAL_HOST_IP` + `KAFKA_EXTERNAL_PORT`。宿主机上的 Kafka 客户端必须能解析到这个 IP。

## 启动顺序

`./start.sh` 读根目录 `.env`，跳过 `docker-compose.example.*`，按这个顺序 `up`：

1. mysql → 2. mongodb → 3. postgresql → 4. redis → 5. kafka → 6. rabbitmq → 7. minio → 8. centrifugo → 9. otel → 10. opensearch

脚本在 `up` 之前做 chown，**不**创建 Docker 网络，也没有名为 `nfx-stack` 的共享网络。chown 的 uid：Grafana **472**、Prometheus **65534**、Loki **10001**、OpenSearch **1000**。否则 `sudo docker` 建成 `root:root`，容器里的非 root 进程会一直 Restarting。

数据路径写在 NFX-Stack 自己的 `.env`：`MYSQL_DATA_PATH`、`MONGO_DATA_PATH`、`POSTGRESQL_DATA_PATH`、`REDIS_DATA_PATH`、`KAFKA_DATA_PATH`、`RABBITMQ_DATA_PATH`、`MINIO_DATA_PATH`，以及 Prometheus / Loki / Grafana / OpenSearch 的 `*_DATA_PATH`。`STORAGES_VOLUME_*` 不属于这里，那是 NFX-Storages 的对象卷。模板里的 `/home/kali/repo` 必须改成 NAS 上的真实目录。

无 AVX 的 CPU 不要把 MongoDB 升过 4.4，本仓固定 `mongo:4.4`。OpenSearch 密码要过 zxcvbn，而且只在数据目录第一次初始化时生效。

```bash
cd /volume1/Projects/NebulaForgeX/NFX-Stack
cp .example.env .env
./start.sh
./start.sh ps
./start.sh logs
```

改端口或密码之后：`./start.sh down && ./start.sh`。`down` 停容器，bind 的数据目录还在。

详细信息见 [NFX-Documentation 第三章](https://github.com/NebulaForgeX/NFX-Documentation/blob/main/books/zh/chapter-03-nfx-stack-deployment.md)。
