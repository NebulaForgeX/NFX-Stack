# NFX Stack

**NFX Stack = NebulaForgeX Resource Stack**

**Unified Resource & Infrastructure Platform for Modern Development**

<div align="center">
  <img src="image.png" alt="NFX Stack Logo" width="200">
</div>

NFX Stack is the foundational infrastructure layer of the NebulaForgeX ecosystem.

It provides a fully-modular, production-grade resource stack designed for rapid application development, local environment consistency, and cloud-ready microservice architectures.

NFX Stack bundles and orchestrates all essential backend services—databases, messaging systems, caching layers, storage engines, and their management UIs—through a single, extensible Docker-based platform.

It empowers developers to spin up a complete, fully integrated environment in minutes, enabling seamless experimentation, prototyping, and scaling across all NebulaForgeX projects.

## Key Features

### Unified Resource Layer
MySQL, PostgreSQL, MongoDB, Redis, Kafka, MinIO (optional), and more—preconfigured and production-hardened.

### Developer-Optimized
Everything runs locally via Docker, ensuring deterministic environments and zero setup friction.

### Service UIs Included
phpMyAdmin, PgAdmin, Mongo Express, RedisInsight, Kafka UI—instant access for debugging and monitoring.

### Microservice-Ready Architecture
Designed as the foundational infrastructure for NebulaForgeX internal services such as Identity, Trend-Radar, Netup, and ReX.

### Extensible & Modular
Add or remove services effortlessly. Ideal for growing ecosystems with diverse backend needs.

### Cloud-Native Practices
Follows patterns used by modern SaaS platforms: isolated networks, persistent volumes, and consistent environment variables.

## Purpose

NFX Stack acts as the backbone of all NebulaForgeX projects, providing:

- A shared development environment
- A standardized resource stack across services
- A reliable foundation for domain-driven architectures
- A single source of truth for data infrastructure
- A launchpad for new microservices and experimental projects

Whether you're building authentication, content pipelines, crawlers, marketplace systems, or AI-driven services, NFX Stack ensures your infrastructure is consistent, predictable, and ready.

---

> **Note**: If you adjust `.env`, please synchronize the host ports in this document; all `*_PORT`, `*_USERNAME`, `*_PASSWORD` values are taken from that file.

## Quick Start

```bash
cd /volume1/NFX-Stack

# 1. Start services
docker compose --env-file .env up -d

# 2. Check status
docker compose ps

# 3. Stop and clean up
docker compose down
```

- Default network: `nfx-stack`; business containers can join this network to access services by name (e.g., `mysql:3306`).
- For physical machine/local access, use the host ports in the table below, and ensure the firewall allows access.

## UI & Management Dashboard Access

| Service | Access URL | Credentials | Notes |
|---------|-----------|-------------|-------|
| phpMyAdmin (`mysql-ui`) | `http://192.168.1.64:${MYSQL_UI_PORT}` (default 10101) | MySQL root or business account (`MYSQL_ROOT_PASSWORD`) | Enter `mysql` (same network) or `192.168.1.64` as Server. |
| Mongo Express (`mongodb-ui`) | `http://192.168.1.64:${MONGO_UI_PORT}` (default 10111) | Basic Auth (`ME_CONFIG_BASICAUTH_*`), then Mongo Root (`MONGO_ROOT_USERNAME/PASSWORD`) | You can change Basic Auth to prevent unauthorized access. |
| RedisInsight (`redis-ui`) | `http://192.168.1.64:${REDIS_UI_PORT}` (default 10121) or `http://192.168.1.64:10027` | If `RI_USERNAME/RI_PASSWORD` is set, login first; when connecting to Redis, enter `redis:6379` or host port | First-time use requires creating a Workspace. |
| Kafka UI (`kafka-ui`) | `http://192.168.1.64:${KAFKA_UI_PORT}` (default 10131) | Optional Basic Auth (custom) | Pre-configured cluster `nfx_stack_public` -> `kafka:9092`. |
| MinIO Console (`minio`) | `http://192.168.1.64:${MINIO_CONSOLE_PORT}` (default 10141) | `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD` | S3 API: `http://192.168.1.64:${MINIO_API_PORT}`, see below for details. |

## Data Plane Ports

| Service | Host Port Env | Default Port | Typical Connection String |
|---------|---------------|--------------|---------------------------|
| MySQL | `MYSQL_DATABASE_PORT` | 10013 | `mysql://root:password@192.168.1.64:10013/db` |
| MongoDB | `MONGO_DATABASE_PORT` | 10014 | `mongodb://root:password@192.168.1.64:10014/?authSource=admin` |
| Redis | `REDIS_DATABASE_PORT` | 10015 | `redis://:password@192.168.1.64:10015/0` |
| Kafka (External) | `KAFKA_EXTERNAL_PORT` | 10109 | `PLAINTEXT://192.168.1.64:10109` |
| MinIO S3 API | `MINIO_API_PORT` | 10141-? (see `.env`) | `http://192.168.1.64:${MINIO_API_PORT}`, Region defaults to `us-east-1` |

> Tips  
> - Only open ports on trusted networks; combine with NAS firewall or router to limit sources.  
> - UI ports and data ports can be changed independently; be sure to sync to `Docs/dev.toml`, `Docs/prod.toml`, otherwise business configurations will fail.  
> - MinIO supports HTTPS; if using self-signed certificates, trust the CA on the client or set `secure = false`.

## MinIO Quick Facts

- API (`MINIO_API_PORT`) provides S3-compatible interface, Console (`MINIO_CONSOLE_PORT`) is for managing users, Buckets, and Policies.
- Business configuration example (complete section provided in `Docs/dev.toml`):

```
[minio]
endpoint = "http://minio:9000"        # Same network
external_endpoint = "http://192.168.1.64:${MINIO_API_PORT}"
access_key = "<MINIO_ROOT_USER>"
secret_key = "<MINIO_ROOT_PASSWORD>"
region = "us-east-1"
bucket = "<PROJECT_BUCKET>"
secure = false
```

- It is recommended to create an independent Bucket for each project and configure access keys with minimal permissions in the Console.

## Configuration Templates / Docs Templates

`NFX-Stack/Docs` provides `dev.toml`, `prod.toml`, covering sections like `[mysql]` `[cache]` `[kafka]` `[mongodb]` `[minio]`:

1. Copy to the `config/` or `configs/` directory of your new service.
2. Replace `REPLACE_WITH_*` with project-specific databases / Topics / Buckets.
3. Choose internal network (`mysql`) or host address (`192.168.1.64:10013`).
4. The MinIO section provides both API and Console URLs for easy object storage configuration injection.

To add more services (such as ElasticSearch, SMTP), extend `docker-compose.yml` and synchronize updates to Templates and this document.
