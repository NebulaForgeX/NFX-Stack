# NFX Stack UI Logs Viewing Guide

## UI Services List

According to `docker-compose.yml`, the following UI services are available in the NFX-Stack directory:

1. **MySQL UI** (phpMyAdmin) - Container: `NFX-Stack-MySQL-UI`
2. **MongoDB UI** (mongo-express) - Container: `NFX-Stack-MongoDB-UI`
3. **PostgreSQL UI** (pgAdmin) - Container: `NFX-Stack-PostgreSQL-UI`
4. **Redis UI** (RedisInsight) - Container: `NFX-Stack-Redis-UI`
5. **Kafka UI** - Container: `NFX-Stack-Kafka-UI`
6. **MinIO** (Web Console) - Container: `NFX-Stack-MinIO`

## Methods to View Logs

### Method 1: Using `sudo docker logs` Command (Recommended)

#### View Logs for a Single UI Service

```bash
# MySQL UI (phpMyAdmin)
sudo docker logs NFX-Stack-MySQL-UI

# MongoDB UI (mongo-express)
sudo docker logs NFX-Stack-MongoDB-UI

# PostgreSQL UI (pgAdmin)
sudo docker logs NFX-Stack-PostgreSQL-UI

# Redis UI (RedisInsight)
sudo docker logs NFX-Stack-Redis-UI

# Kafka UI
sudo docker logs NFX-Stack-Kafka-UI

# MinIO (Web Console)
sudo docker logs NFX-Stack-MinIO
```

#### Real-time Log Tracking (similar to tail -f)

```bash
# Real-time MySQL UI logs
sudo docker logs -f NFX-Stack-MySQL-UI

# Real-time MongoDB UI logs
sudo docker logs -f NFX-Stack-MongoDB-UI

# Real-time PostgreSQL UI logs
sudo docker logs -f NFX-Stack-PostgreSQL-UI

# Real-time Redis UI logs
sudo docker logs -f NFX-Stack-Redis-UI

# Real-time Kafka UI logs
sudo docker logs -f NFX-Stack-Kafka-UI

# Real-time MinIO logs
sudo docker logs -f NFX-Stack-MinIO
```

#### View Recent Logs (Last N Lines)

```bash
# View last 100 lines
sudo docker logs --tail 100 NFX-Stack-MySQL-UI

# View last 50 lines and follow in real-time
sudo docker logs --tail 50 -f NFX-Stack-MongoDB-UI
```

#### View Logs with Timestamps

```bash
# Display timestamps
sudo docker logs -t NFX-Stack-PostgreSQL-UI

# Real-time tracking with timestamps
sudo docker logs -f -t NFX-Stack-Redis-UI
```

#### View Logs for a Specific Time Range

```bash
# View logs from last 10 minutes
sudo docker logs --since 10m NFX-Stack-Kafka-UI

# View logs from last 1 hour
sudo docker logs --since 1h NFX-Stack-MinIO

# View logs from a specific time point
sudo docker logs --since "2025-01-20T10:00:00" NFX-Stack-MySQL-UI

# View logs within a specific time range
sudo docker logs --since "2025-01-20T10:00:00" --until "2025-01-20T11:00:00" NFX-Stack-MongoDB-UI
```

### Method 2: Using `sudo docker compose logs` Command (Recommended)

Execute in the `/volume1/Resources` directory:

```bash
cd /volume1/Resources

# View logs for all UI services
sudo docker compose --env-file .env logs mysql-ui mongodb-ui postgresql-ui redis-ui kafka-ui

# View logs for a single UI service
sudo docker compose --env-file .env logs mysql-ui
sudo docker compose --env-file .env logs mongodb-ui
sudo docker compose --env-file .env logs postgresql-ui
sudo docker compose --env-file .env logs redis-ui
sudo docker compose --env-file .env logs kafka-ui

# Real-time tracking for all UI services
sudo docker compose --env-file .env logs -f mysql-ui mongodb-ui postgresql-ui redis-ui kafka-ui

# View last 100 lines
sudo docker compose --env-file .env logs --tail 100 mysql-ui

# View logs with timestamps
sudo docker compose --env-file .env logs -t mysql-ui
```

### Method 3: View All UI Service Logs (One-Click View)

```bash
# View logs for all NFX Stack UI services
sudo docker logs NFX-Stack-MySQL-UI NFX-Stack-MongoDB-UI NFX-Stack-PostgreSQL-UI NFX-Stack-Redis-UI NFX-Stack-Kafka-UI NFX-Stack-MinIO

# Real-time tracking for all UI services
sudo docker logs -f NFX-Stack-MySQL-UI NFX-Stack-MongoDB-UI NFX-Stack-PostgreSQL-UI NFX-Stack-Redis-UI NFX-Stack-Kafka-UI NFX-Stack-MinIO
```

### Method 4: Using Script for Batch Viewing

Create a script file `view-ui-logs.sh`:

```bash
#!/bin/bash

echo "=== NFX Stack UI Service Log Viewer ==="
echo ""
echo "1. MySQL UI (phpMyAdmin)"
echo "2. MongoDB UI (mongo-express)"
echo "3. PostgreSQL UI (pgAdmin)"
echo "4. Redis UI (RedisInsight)"
echo "5. Kafka UI"
echo "6. MinIO"
echo "7. View all UI service logs"
echo "0. Exit"
echo ""

read -p "Please select a service (0-7): " choice

case $choice in
    1)
        sudo docker logs -f NFX-Stack-MySQL-UI
        ;;
    2)
        sudo docker logs -f NFX-Stack-MongoDB-UI
        ;;
    3)
        sudo docker logs -f NFX-Stack-PostgreSQL-UI
        ;;
    4)
        sudo docker logs -f NFX-Stack-Redis-UI
        ;;
    5)
        sudo docker logs -f NFX-Stack-Kafka-UI
        ;;
    6)
        sudo docker logs -f NFX-Stack-MinIO
        ;;
    7)
        echo "Viewing all UI service logs..."
        sudo docker logs -f NFX-Stack-MySQL-UI NFX-Stack-MongoDB-UI NFX-Stack-PostgreSQL-UI NFX-Stack-Redis-UI NFX-Stack-Kafka-UI NFX-Stack-MinIO
        ;;
    0)
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac
```

## Common Command Combinations

### View Error Logs

```bash
# View logs containing "error"
sudo docker logs NFX-Stack-MySQL-UI 2>&1 | grep -i error

# View logs containing "error" or "warn"
sudo docker logs NFX-Stack-MongoDB-UI 2>&1 | grep -iE "error|warn"
```

### Export Logs to File

```bash
# Export MySQL UI logs to file
sudo docker logs NFX-Stack-MySQL-UI > mysql-ui.log 2>&1

# Export all UI service logs
sudo docker logs NFX-Stack-MySQL-UI > mysql-ui.log 2>&1
sudo docker logs NFX-Stack-MongoDB-UI > mongodb-ui.log 2>&1
sudo docker logs NFX-Stack-PostgreSQL-UI > postgresql-ui.log 2>&1
sudo docker logs NFX-Stack-Redis-UI > redis-ui.log 2>&1
sudo docker logs NFX-Stack-Kafka-UI > kafka-ui.log 2>&1
sudo docker logs NFX-Stack-MinIO > minio.log 2>&1
```

### View Container Status and Logs

```bash
# First check container status
sudo docker ps --filter "name=NFX-Stack" --format "table {{.Names}}\t{{.Status}}"

# Then view logs for the corresponding container
sudo docker logs -f <container-name>
```

## Notes

1. **Permissions**: This system requires `sudo` to execute Docker commands
2. **Command Format**: Use `sudo docker compose` (Docker Compose V2) instead of `docker-compose`
3. **Log Size**: Docker logs may consume significant disk space; regularly clean or configure log rotation
4. **Real-time Tracking**: When using the `-f` parameter, press `Ctrl+C` to exit real-time tracking
5. **Log Limits**: Docker limits log size by default; you can configure log driver and size limits in `docker-compose.yml`

## Configure Log Limits (Optional)

Add logging configuration to services in `docker-compose.yml`:

```yaml
services:
  mysql-ui:
    # ... other configurations ...
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

This limits each log file to a maximum of 10MB and retains up to 3 files.

