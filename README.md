# NFX-Stack

[English](README.en.md)

NebulaForgeX 数据面（MySQL、PostgreSQL、MongoDB、Redis、Kafka、RabbitMQ、MinIO、Centrifugo、OTEL、OpenSearch）。发布在局域网 `10000–10024`。**不**跑 Traefik。

部署与端口、故障：[NFX-Documentation 第三章](https://github.com/NebulaForgeX/NFX-Documentation/blob/main/books/zh/chapter-03-nfx-stack-deployment.md)。HTTP 入口是 [NFX-Edge](https://github.com/NebulaForgeX/NFX-Edge)。

```bash
cp .example.env .env
./start.sh
```

宿主机端口 **10000–10024**（Postgres **10004**、Redis **10006**、Kafka **10008**）。**10025–10029** 预留。
