# NFX Stack 部署指南

[English Version](en/DEPLOYMENT.md)

## 前置要求

- Docker 20.10+、Docker Compose v2
- 磁盘建议 ≥ 10GB；内存建议 ≥ 4GB（OpenSearch / OTEL 会再占一些）
- 本机 CPU 无 AVX 时不要升级 MongoDB 到 5.0+

## 快速部署

```bash
cd /path/to/NFX-Stack
cp .example.env .env
# 编辑 .env：密码、绑定 IP、端口、数据路径

./start.sh          # 创建 nfx-stack 网络并 up -d 全部栈
./start.sh ps       # 状态
./start.sh logs     # 最近日志
./start.sh down     # 停止并删除容器（数据卷/绑定目录保留）
```

单独拉起某一栈（示例）：

```bash
docker compose --project-directory Infrastructure --env-file .env \
  -f Infrastructure/docker-compose.mysql.yml up -d
```

## 端口（以 `.env` 为准）

当前 NAS 示例绑定 `192.168.1.64`：

| 服务 | 数据/API | UI |
|------|----------|-----|
| MySQL | 10100 | 10101 phpMyAdmin |
| MongoDB | 10102 | 10103 |
| PostgreSQL | 10104 | 10105 pgAdmin |
| Redis | 10106 | 10107 RedisInsight |
| Kafka | 10108 | 10109 |
| RabbitMQ AMQP | 10110 | 10111 Management |
| MinIO S3 | 10112 | 10113 Console |
| Centrifugo | 10114 | 同端口 Admin |
| Jaeger | — | 10115 |
| OTLP gRPC / HTTP | 10116 / 10117 | Collector health 10118 |
| Prometheus exporter / Prometheus / Loki | 10119 / 10120 / 10121 | Grafana 10122 |
| OpenSearch | 10123 HTTPS | 10124 Dashboards HTTP |

防火墙只对受信网段开放这些端口。

## 维护

```bash
./version.sh                 # 检查镜像版本（需 sudo docker）
docker pull mysql:9.7.2    # 按需拉取后 ./start.sh 重建
```

改 `.env` 里的端口或密码后执行 `./start.sh down && ./start.sh`。  
OpenSearch 的 `OPENSEARCH_PASSWORD` **仅首次初始化数据目录时生效**；改密需清空 `OPENSEARCH_DATA_PATH` 再启动。

## 故障

- 网络不存在：`./start.sh` 会创建；也可 `docker network create nfx-stack`
- 端口占用：改 `.env` 对应 `*_PORT`
- Mongo 起不来：确认镜像仍是 `mongo:4.4`
- OpenSearch 起不来：密码须过 zxcvbn；数据目录须对 uid 1000 可写（`./start.sh` 会 `chown`）；堆内存见 `OPENSEARCH_JAVA_OPTS`
- Grafana / Prometheus / Loki 一直 Restarting：数据目录被 `sudo docker` 建成 `root:root`，镜像内非 root 写不进去。`./start.sh` 会分别 `chown` 472 / 65534 / 10001
- MinIO 起不来 / 数据目录报错：从 AIStor 换成社区版后若 `/data` 格式不兼容，清空 `MINIO_DATA_PATH` 再 `./start.sh`
