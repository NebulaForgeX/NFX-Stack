# NFX Stack Project Structure

This document details the directory structure and organization of the NFX Stack project.

[中文版本](../STRUCTURE.md)

## Directory Structure

```
Resources/
├── .env                    # Environment variable configuration file (copy from .example.env)
├── .example.env            # Environment variable configuration template
├── docker-compose.yml      # Docker Compose configuration file
├── README.md               # Main project documentation (Chinese)
├── image.png               # Project Logo
├── VIEW_UI_LOGS.md         # UI logs viewing guide
├── Databases/              # Database data persistence directory
│   ├── mysql/              # MySQL data directory
│   ├── mongodb/            # MongoDB data directory
│   ├── postgresql/         # PostgreSQL data directory
│   ├── redis/              # Redis data directory
│   └── kafka/              # Kafka data directory
├── Docs/                   # Documentation directory
│   ├── README.md           # Configuration documentation usage guide (Chinese)
│   ├── STRUCTURE.md        # Project structure documentation (Chinese)
│   ├── DEPLOYMENT.md       # Deployment guide (Chinese)
│   ├── CONFIGURATION.md    # Configuration details (Chinese)
│   ├── dev.toml            # Development environment configuration template
│   ├── prod.toml           # Production environment configuration template
│   └── en/                 # English documentation directory
│       ├── README.md
│       ├── STRUCTURE.md
│       ├── DEPLOYMENT.md
│       └── CONFIGURATION.md
└── Shared/                 # Shared resources directory (optional)
```

## Core Components

### Docker Compose Services

NFX Stack defines the following services through `docker-compose.yml`:

#### Database Services

1. **MySQL** (`mysql`)
   - Container name: `NFX-Stack-MySQL`
   - Image: `mysql:8.0`
   - Data directory: `${MYSQL_DATA_PATH}`
   - Initialization script directory: `${MYSQL_INIT_PATH}`

2. **PostgreSQL** (`postgresql`)
   - Container name: `NFX-Stack-PostgreSQL`
   - Image: `postgres:15-alpine`
   - Data directory: `${POSTGRESQL_DATA_PATH}`
   - Initialization script directory: `${POSTGRESQL_INIT_PATH}`

3. **MongoDB** (`mongodb`)
   - Container name: `NFX-Stack-MongoDB`
   - Image: `mongo:4.4`
   - Data directory: `${MONGO_DATA_PATH}`
   - Initialization script directory: `${MONGO_INIT_PATH}`

4. **Redis** (`redis`)
   - Container name: `NFX-Stack-Redis`
   - Image: `redis:7-alpine`
   - Data directory: `${REDIS_DATA_PATH}`

#### Message Queue Service

5. **Kafka** (`kafka`)
   - Container name: `NFX-Stack-Kafka`
   - Image: `apache/kafka:latest`
   - Data directory: `${KAFKA_DATA_PATH}`
   - Uses KRaft mode (single node)

#### Object Storage Service (Optional)

6. **MinIO** (`minio`)
   - Container name: `NFX-Stack-MinIO`
   - Image: `minio/minio:RELEASE.*`
   - Data directory: `${MINIO_DATA_PATH}`
   - Provides S3-compatible API and management console

#### Management UI Services

7. **phpMyAdmin** (`mysql-ui`)
   - Container name: `NFX-Stack-MySQL-UI`
   - Image: `phpmyadmin:latest`
   - For managing MySQL

8. **pgAdmin** (`postgresql-ui`)
   - Container name: `NFX-Stack-PostgreSQL-UI`
   - Image: `dpage/pgadmin4:latest`
   - For managing PostgreSQL

9. **Mongo Express** (`mongodb-ui`)
   - Container name: `NFX-Stack-MongoDB-UI`
   - Image: `mongo-express:latest`
   - For managing MongoDB

10. **RedisInsight** (`redis-ui`)
    - Container name: `NFX-Stack-Redis-UI`
    - Image: `redis/redisinsight:latest`
    - For managing Redis

11. **Kafka UI** (`kafka-ui`)
    - Container name: `NFX-Stack-Kafka-UI`
    - Image: `provectuslabs/kafka-ui:latest`
    - For managing Kafka

## Network Architecture

### Docker Network

- **Network name**: `nfx-stack`
- **Network type**: `bridge`
- **Purpose**: All services are in the same network and can access each other by container name

### Inter-Service Communication

- **Container-internal access**: Use container name and internal port (e.g., `mysql:3306`)
- **Host access**: Use host IP and mapped port (e.g., `192.168.1.64:10013`)

## Data Persistence

All database and storage service data are persisted to corresponding subdirectories under `Databases/`:

- Data directories are configured through environment variables (`*_DATA_PATH`)
- Initialization script directories are configured through environment variables (`*_INIT_PATH`)
- Data is retained after container restarts

## Configuration Templates

The `Docs/` directory provides configuration templates:

- **dev.toml**: Development environment configuration template
- **prod.toml**: Production environment configuration template

These templates contain connection configurations for all services and can be directly copied into business services for use.

## Environment Variables

All configurations are managed through the `.env` file:

- Port configurations (`*_PORT`)
- Authentication information (`*_PASSWORD`, `*_USERNAME`)
- Data paths (`*_DATA_PATH`)
- Network bindings (`*_HOST`)

For detailed configuration instructions, please refer to [CONFIGURATION.md](CONFIGURATION.md).

## Extensibility

### Adding New Services

1. Add service definition in `docker-compose.yml`
2. Add corresponding environment variables in `.env`
3. Update `Docs/dev.toml` and `Docs/prod.toml` templates
4. Update this document

### Removing Services

1. Comment out or delete service definition in `docker-compose.yml`
2. Remove related environment variables from `.env` (optional)
3. Remove corresponding configuration sections from templates (optional)

---

## Support

**Developer**: Lucas Lyu  
**Contact**: lyulucas2003@gmail.com

