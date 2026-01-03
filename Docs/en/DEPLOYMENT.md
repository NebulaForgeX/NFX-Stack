# NFX Stack Deployment Guide

This document provides deployment instructions for NFX Stack in different environments.

[中文版本](../DEPLOYMENT.md)

## Prerequisites

### System Requirements

- **Operating System**: Linux (recommended Ubuntu 20.04+ or Debian 11+), macOS, Windows (WSL2)
- **Docker**: Version 20.10 or higher
- **Docker Compose**: Version 2.0 or higher
- **Disk Space**: At least 10GB free space (for database data storage)
- **Memory**: Recommended at least 4GB RAM

### Software Installation

#### Install Docker

**Ubuntu/Debian**:
```bash
# Update package index
sudo apt-get update

# Install necessary dependencies
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

**macOS**:
```bash
# Using Homebrew
brew install --cask docker
```

**Windows**:
- Download and install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)

#### Verify Installation

```bash
docker --version
docker compose version
```

## Quick Deployment

### 1. Clone or Download Project

```bash
cd /volume1
# If project is in Git repository
# git clone <repository-url> Resources
# Or use existing directory
cd Resources
```

### 2. Configure Environment Variables

```bash
# Copy environment variable template
cp .example.env .env

# Edit .env file, set all necessary configurations
# At minimum, need to set:
# - All *_PASSWORD variables
# - All *_PORT variables (if custom ports are needed)
# - All *_DATA_PATH variables (if custom data paths are needed)
nano .env  # or use your preferred editor
```

### 3. Start Services

```bash
# Start all services (run in background)
docker compose --env-file .env up -d

# Check service status
docker compose ps

# View logs
docker compose logs -f
```

### 4. Verify Deployment

```bash
# Check if all containers are running
docker compose ps

# Should see all services with status "Up"
```

Access each management interface to verify services are working:

- MySQL UI: `http://<your-ip>:${MYSQL_UI_PORT}`
- MongoDB UI: `http://<your-ip>:${MONGO_UI_PORT}`
- Redis UI: `http://<your-ip>:${REDIS_UI_PORT}`
- Kafka UI: `http://<your-ip>:${KAFKA_UI_PORT}`

## Production Deployment

### Security Configuration

1. **Change Default Passwords**
   - Ensure all `*_PASSWORD` variables use strong passwords
   - Recommend using password generator to create random passwords

2. **Network Security**
   - Only open ports on internal or trusted networks
   - Use firewall to limit access sources
   - Consider using VPN for remote access

3. **Data Backup**
   - Regularly backup `Databases/` directory
   - Configure automatic backup scripts
   - Store backups in secure location

### Performance Optimization

1. **Resource Limits**
   Add resource limits for each service in `docker-compose.yml`:

```yaml
services:
  mysql:
    # ... other configurations ...
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
```

2. **Data Directory Optimization**
   - Place data directories on high-performance storage (SSD)
   - Consider using Docker volumes instead of bind mounts

3. **Log Management**
   Configure log rotation to prevent disk space exhaustion:

```yaml
services:
  mysql:
    # ... other configurations ...
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### High Availability (Optional)

For production environments, consider:

1. **Database Master-Slave Replication**
   - MySQL master-slave replication
   - PostgreSQL streaming replication
   - MongoDB replica sets

2. **Kafka Cluster**
   - Deploy multi-node Kafka cluster
   - Configure replication and partition strategies

3. **Load Balancing**
   - Use Nginx or Traefik for load balancing
   - Configure health checks

## Maintenance Operations

### Stop Services

```bash
# Stop all services (preserve data)
docker compose stop

# Stop and remove containers (preserve data)
docker compose down
```

### Restart Services

```bash
# Restart all services
docker compose restart

# Restart specific service
docker compose restart mysql
```

### Update Services

```bash
# Pull latest images
docker compose pull

# Recreate and start containers
docker compose up -d
```

### View Logs

```bash
# View all service logs
docker compose logs -f

# View specific service logs
docker compose logs -f mysql

# View last 100 lines of logs
docker compose logs --tail 100 mysql
```

### Data Backup

```bash
# Backup MySQL
docker compose exec mysql mysqldump -u root -p${MYSQL_ROOT_PASSWORD} --all-databases > backup.sql

# Backup PostgreSQL
docker compose exec postgresql pg_dumpall -U ${POSTGRESQL_ROOT_USERNAME} > backup.sql

# Backup MongoDB
docker compose exec mongodb mongodump --out /backup

# Backup Redis
docker compose exec redis redis-cli --rdb /data/dump.rdb
```

### Data Restore

```bash
# Restore MySQL
docker compose exec -T mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} < backup.sql

# Restore PostgreSQL
docker compose exec -T postgresql psql -U ${POSTGRESQL_ROOT_USERNAME} < backup.sql

# Restore MongoDB
docker compose exec mongodb mongorestore /backup

# Restore Redis
docker compose exec redis redis-cli --rdb /data/dump.rdb
```

## Troubleshooting

### Containers Cannot Start

1. Check logs:
```bash
docker compose logs <service-name>
```

2. Check port conflicts:
```bash
netstat -tulpn | grep <port>
```

3. Check disk space:
```bash
df -h
```

### Services Cannot Connect

1. Check network:
```bash
docker network inspect nfx-stack
```

2. Check container status:
```bash
docker compose ps
```

3. Test connection:
```bash
docker compose exec mysql mysql -u root -p
```

### Performance Issues

1. Check resource usage:
```bash
docker stats
```

2. Check error messages in logs
3. Consider increasing resource limits or optimizing configuration

## Uninstallation

```bash
# Stop and remove all containers and networks (preserve data)
docker compose down

# Delete all data (use with caution!)
sudo rm -rf Databases/

# Remove images (optional)
docker compose down --rmi all
```

---

## Support

**Developer**: Lucas Lyu  
**Contact**: lyulucas2003@gmail.com

