# NFX-Stack

[English](README.en.md)

NebulaForgeX 数据面（MySQL、PostgreSQL、MongoDB、Redis、Kafka、RabbitMQ、MinIO、Centrifugo、OTEL、OpenSearch）。网络名 `nfx-stack`。**不**跑 Traefik。

部署与端口、故障：[NFX-Documentation 第三章](https://github.com/NebulaForgeX/NFX-Documentation/blob/main/books/zh/chapter-03-nfx-stack-deployment.md)。HTTP 入口是 [NFX-Edge](https://github.com/NebulaForgeX/NFX-Edge)。

```bash
cp .example.env .env
./start.sh
```

宿主机端口从 **10100** 起连续无洞（产品默认 Postgres **10104**、Redis **10106**、Kafka **10108**）。
