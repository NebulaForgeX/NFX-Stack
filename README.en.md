# NFX-Stack

[中文](README.md)

NebulaForgeX data plane (MySQL, PostgreSQL, MongoDB, Redis, Kafka, RabbitMQ, MinIO, Centrifugo, OTEL, OpenSearch). Published on the LAN at `10000–10024`. Does **not** run Traefik.

Deploy, ports, troubleshooting: [NFX-Documentation chapter 3](https://github.com/NebulaForgeX/NFX-Documentation/blob/main/books/en/chapter-03-nfx-stack-deployment.md). HTTP ingress is [NFX-Edge](https://github.com/NebulaForgeX/NFX-Edge).

```bash
cp .example.env .env
./start.sh
```

Host ports **10000–10024** (Postgres **10004**, Redis **10006**, Kafka **10008**). **10025–10029** is reserved.
