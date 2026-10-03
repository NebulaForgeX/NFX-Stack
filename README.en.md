# NFX-Stack

[中文](README.md)

<div align="center">
  <img src="image.png" alt="NFX-Stack" width="200">
</div>

The NebulaForgeX data plane. Identity, Edge, News, and Storages get Postgres, Redis, Kafka, MinIO, and OTLP from here. Do not start a second copy inside those repos. Products connect at `NAS_IP:host port` and do **not** join a shared Docker network. A process uses a compose service name only when it lives in the same file (Kafka UI → `kafka:9092`).

This repo does **not** run Traefik. HTTP/HTTPS ingress is [NFX-Edge](https://github.com/NebulaForgeX/NFX-Edge), which owns host 80/443. These ports stay on a trusted LAN. Bind the LAN IP from `.env` (for example `192.168.1.64`). Do not publish `0.0.0.0` to the internet.

## Host ports

Sequential from **10000**. **10025–10029** is reserved. Product clients use the bold ports.

| Service | Data / API | UI |
|---------|------------|-----|
| MySQL | **10000** | 10001 phpMyAdmin |
| MongoDB | 10002 | 10003 mongo-express |
| PostgreSQL | **10004** | 10005 pgAdmin |
| Redis | **10006** | 10007 RedisInsight |
| Kafka EXTERNAL | **10008** | 10009 Kafka UI |
| RabbitMQ AMQP | 10010 | 10011 Management |
| MinIO S3 | **10012** | 10013 Console (path-style required) |
| Centrifugo | 10014 | admin on the same port |
| Jaeger | — | 10015 |
| OTLP gRPC / HTTP | **10016** / 10017 | collector health 10018 |
| Collector Prometheus / Prometheus / Loki | 10019 / 10020 / 10021 | Grafana 10022 |
| OpenSearch | 10023 HTTPS | 10024 Dashboards HTTP |

`KAFKA_ADVERTISED_LISTENERS` uses `KAFKA_INTERNAL_HOST_IP` + `KAFKA_EXTERNAL_PORT`. Kafka clients on the host must resolve that IP.

## Start order

`./start.sh` reads the root `.env`, skips `docker-compose.example.*`, and runs `up` in this order:

1. mysql → 2. mongodb → 3. postgresql → 4. redis → 5. kafka → 6. rabbitmq → 7. minio → 8. centrifugo → 9. otel → 10. opensearch

Before `up` it chowns data directories. It does **not** create a Docker network, and there is no shared network named `nfx-stack`. chown uids: Grafana **472**, Prometheus **65534**, Loki **10001**, OpenSearch **1000**. Otherwise `sudo docker` creates `root:root` directories and the non-root process inside the image keeps restarting.

Data paths belong in the NFX-Stack `.env`: `MYSQL_DATA_PATH`, `MONGO_DATA_PATH`, `POSTGRESQL_DATA_PATH`, `REDIS_DATA_PATH`, `KAFKA_DATA_PATH`, `RABBITMQ_DATA_PATH`, `MINIO_DATA_PATH`, plus the Prometheus / Loki / Grafana / OpenSearch `*_DATA_PATH` keys. `STORAGES_VOLUME_*` is not a Stack path. Those are NFX-Storages object volumes. Replace the `/home/kali/repo` placeholders with real NAS directories.

On a CPU without AVX, do not raise MongoDB past 4.4. This repo pins `mongo:4.4`. The OpenSearch password must pass zxcvbn, and it applies only the first time the data directory is initialized.

```bash
cd /volume1/Projects/NebulaForgeX/NFX-Stack
cp .example.env .env
./start.sh
./start.sh ps
./start.sh logs
```

After a port or password change: `./start.sh down && ./start.sh`. `down` stops containers and leaves the bind-mounted data in place.

Full detail: [NFX-Documentation chapter 3](https://github.com/NebulaForgeX/NFX-Documentation/blob/main/books/en/chapter-03-nfx-stack-deployment.md).
