# NFX-Stack

[中文](README.md)

NebulaForgeX data plane (MySQL, PostgreSQL, MongoDB, Redis, Kafka, RabbitMQ, MinIO, Centrifugo, OTEL, OpenSearch). Network name `nfx-stack`. Does **not** run Traefik.

Deploy, ports, troubleshooting: [NFX-Documentation chapter 3](https://github.com/NebulaForgeX/NFX-Documentation/blob/main/books/en/chapter-03-nfx-stack-deployment.md). HTTP ingress is [NFX-Edge](https://github.com/NebulaForgeX/NFX-Edge).

```bash
cp .example.env .env
./start.sh
```

Host ports start at **10100** with no gaps (product defaults: Postgres **10104**, Redis **10106**, Kafka **10108**).
