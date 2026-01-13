# NFX Stack Configuration Guide

This document provides detailed explanations of all NFX Stack configuration options.

[中文版本](../CONFIGURATION.md)

## Configuration File

NFX Stack uses the `.env` file for configuration. All configuration items are passed to Docker containers through environment variables.

### Create Configuration File

```bash
# Copy from template
cp .example.env .env

# Edit configuration file
nano .env
```

## Configuration Categories

### MySQL Configuration

```bash
# MySQL root user (default cannot be changed)
MYSQL_ROOT_USERNAME=root

# MySQL root password (must be set)
MYSQL_ROOT_PASSWORD=<YOUR_MYSQL_ROOT_PASSWORD>

# MySQL database port binding IP
MYSQL_DATABASE_HOST=0.0.0.0  # 0.0.0.0 means all interfaces, 127.0.0.1 means local only

# MySQL database port
MYSQL_DATABASE_PORT=10013

# MySQL UI port binding IP
MYSQL_UI_HOST=0.0.0.0

# MySQL UI port
MYSQL_UI_PORT=10101

# MySQL data directory
MYSQL_DATA_PATH=/home/kali/repo/Databases/mysql

# MySQL initialization script directory
MYSQL_INIT_PATH=/home/kali/repo/Databases/mysql-init
```

### PostgreSQL Configuration

```bash
# PostgreSQL root username
POSTGRESQL_ROOT_USERNAME=postgres

# PostgreSQL root password
POSTGRESQL_ROOT_PASSWORD=<YOUR_POSTGRESQL_ROOT_PASSWORD>

# PostgreSQL database port binding IP
POSTGRESQL_DATABASE_HOST=0.0.0.0

# PostgreSQL database port
POSTGRESQL_DATABASE_PORT=10016

# PostgreSQL UI port binding IP
POSTGRESQL_UI_HOST=0.0.0.0

# PostgreSQL UI port
POSTGRESQL_UI_PORT=10106

# PostgreSQL UI username (email format)
POSTGRESQL_UI_USERNAME=admin@admin.com

# PostgreSQL UI password
POSTGRESQL_UI_PASSWORD=<YOUR_POSTGRESQL_UI_PASSWORD>

# PostgreSQL data directory
POSTGRESQL_DATA_PATH=/home/kali/repo/Databases/postgresql

# PostgreSQL initialization script directory
POSTGRESQL_INIT_PATH=/home/kali/repo/Databases/postgresql-init
```

### MongoDB Configuration

```bash
# MongoDB root username
MONGO_ROOT_USERNAME=<YOUR_MONGO_ROOT_USERNAME>

# MongoDB root password
MONGO_ROOT_PASSWORD=<YOUR_MONGO_ROOT_PASSWORD>

# MongoDB database port binding IP
MONGO_DATABASE_HOST=0.0.0.0

# MongoDB database port
MONGO_DATABASE_PORT=10014

# MongoDB UI username (Basic Auth)
MONGO_UI_USERNAME=<YOUR_MONGO_UI_USERNAME>

# MongoDB UI password (Basic Auth)
MONGO_UI_PASSWORD=<YOUR_MONGO_UI_PASSWORD>

# MongoDB UI port binding IP
MONGO_UI_HOST=0.0.0.0

# MongoDB UI port
MONGO_UI_PORT=10111

# MongoDB data directory
MONGO_DATA_PATH=/home/kali/repo/Databases/mongodb

# MongoDB initialization script directory
MONGO_INIT_PATH=/home/kali/repo/Databases/mongodb-init
```

### Redis Configuration

```bash
# Redis password
REDIS_PASSWORD=<YOUR_REDIS_PASSWORD>

# Redis database port binding IP
REDIS_DATABASE_HOST=0.0.0.0

# Redis database port
REDIS_DATABASE_PORT=10015

# Redis UI port binding IP
REDIS_UI_HOST=0.0.0.0

# Redis UI port
REDIS_UI_PORT=10121

# Redis data directory
REDIS_DATA_PATH=/home/kali/repo/Databases/redis
```

### Kafka Configuration

```bash
# Kafka internal IP (for ADVERTISED_LISTENERS)
KAFKA_INTERNAL_HOST_IP=192.168.1.64

# Kafka external port binding IP
KAFKA_EXTERNAL_HOST=0.0.0.0

# Kafka external port
KAFKA_EXTERNAL_PORT=10109

# Kafka UI port binding IP
KAFKA_UI_HOST=0.0.0.0

# Kafka UI port
KAFKA_UI_PORT=10131

# Kafka data directory
KAFKA_DATA_PATH=/home/kali/repo/Databases/kafka
```

### MinIO Configuration (Optional)

```bash
# MinIO root user
MINIO_ROOT_USER=<YOUR_MINIO_ROOT_USER>

# MinIO root password
MINIO_ROOT_PASSWORD=<YOUR_MINIO_ROOT_PASSWORD>

# MinIO API port binding IP
MINIO_API_HOST=0.0.0.0

# MinIO API port (S3-compatible interface)
MINIO_API_PORT=10141

# MinIO UI port binding IP
MINIO_UI_HOST=0.0.0.0

# MinIO UI port (management console)
MINIO_UI_PORT=10142

# MinIO data directory
MINIO_DATA_PATH=/home/kali/repo//Stores
```

## Port Configuration

### Default Port Allocation

| Service | Data Port | UI Port | Notes |
|---------|-----------|---------|-------|
| MySQL | 10013 | 10101 | Database and phpMyAdmin |
| PostgreSQL | 10016 | 10106 | Database and pgAdmin |
| MongoDB | 10014 | 10111 | Database and Mongo Express |
| Redis | 10015 | 10121 | Database and RedisInsight |
| Kafka | 10109 | 10131 | Message queue and Kafka UI |
| MinIO | 10141 | 10142 | S3 API and management console |

### Port Conflict Handling

If default ports are already in use, modify the corresponding port configuration in the `.env` file.

**Note**: After modifying ports, you need to synchronize:
1. Port configurations in `Docs/dev.toml` and `Docs/prod.toml`
2. Business service configuration files
3. Firewall rules

## Network Configuration

### Binding IP Explanation

- `0.0.0.0`: Bind all network interfaces, allow access from any IP
- `127.0.0.1`: Bind only local loopback interface, only accessible from local machine
- `192.168.1.64`: Bind specific IP, only accessible from that IP

### Security Recommendations

- **Development Environment**: Can use `0.0.0.0` for convenient debugging
- **Production Environment**: Recommend using specific IP or `127.0.0.1`, and restrict access through firewall

## Data Directory Configuration

### Path Explanation

All data directories are configured through environment variables, supporting absolute and relative paths:

- **Absolute path**: `/home/kali/repo/Databases/mysql`
- **Relative path**: `./Databases/mysql` (relative to docker-compose.yml directory)

### Permission Requirements

Ensure Docker has permission to access data directories:

```bash
# Create directories
mkdir -p Databases/mysql Databases/mongodb Databases/postgresql Databases/redis Databases/kafka

# Set permissions (if needed)
sudo chown -R $USER:$USER Databases/
```

## Initialization Scripts

### MySQL Initialization

Place SQL scripts in `MYSQL_INIT_PATH` directory, they will be automatically executed when container starts:

```bash
# Create initialization script directory
mkdir -p Databases/mysql-init

# Add initialization script
echo "CREATE DATABASE IF NOT EXISTS myapp;" > Databases/mysql-init/init.sql
```

### PostgreSQL Initialization

Place SQL scripts in `POSTGRESQL_INIT_PATH` directory:

```bash
mkdir -p Databases/postgresql-init
echo "CREATE DATABASE myapp;" > Databases/postgresql-init/init.sql
```

### MongoDB Initialization

Place JavaScript scripts in `MONGO_INIT_PATH` directory:

```bash
mkdir -p Databases/mongodb-init
echo "db.createUser({user: 'myuser', pwd: 'mypass', roles: ['readWrite']})" > Databases/mongodb-init/init.js
```

## Configuration Validation

### Check Configuration

```bash
# Verify environment variables are loaded correctly
docker compose config

# Check specific service configuration
docker compose config mysql
```

### Test Connections

```bash
# Test MySQL
docker compose exec mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SELECT 1"

# Test PostgreSQL
docker compose exec postgresql psql -U ${POSTGRESQL_ROOT_USERNAME} -c "SELECT 1"

# Test Redis
docker compose exec redis redis-cli -a ${REDIS_PASSWORD} ping

# Test MongoDB
docker compose exec mongodb mongo -u ${MONGO_ROOT_USERNAME} -p${MONGO_ROOT_PASSWORD} --eval "db.adminCommand('ping')"
```

## Configuration Templates

The `Docs/` directory provides configuration templates:

- **dev.toml**: Development environment configuration template
- **prod.toml**: Production environment configuration template

These templates can be directly copied into business services for use, just replace placeholders.

For detailed usage, please refer to [README.md](README.md).

---

## Support

**Developer**: Lucas Lyu  
**Contact**: lyulucas2003@gmail.com

