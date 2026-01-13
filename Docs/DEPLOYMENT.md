# NFX Stack 部署指南

本文档提供 NFX Stack 在不同环境下的部署说明。

[English Version](en/DEPLOYMENT.md)

## 前置要求

### 系统要求

- **操作系统**：Linux（推荐 Ubuntu 20.04+ 或 Debian 11+）、macOS、Windows（WSL2）
- **Docker**：版本 20.10 或更高
- **Docker Compose**：版本 2.0 或更高
- **磁盘空间**：至少 10GB 可用空间（用于数据库数据存储）
- **内存**：建议至少 4GB RAM

### 软件安装

#### 安装 Docker

**Ubuntu/Debian**：
```bash
# 更新包索引
sudo apt-get update

# 安装必要的依赖
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# 添加 Docker 官方 GPG 密钥
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 设置 Docker 仓库
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装 Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

**macOS**：
```bash
# 使用 Homebrew
brew install --cask docker
```

**Windows**：
- 下载并安装 [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)

#### 验证安装

```bash
docker --version
docker compose version
```

## 快速部署

### 1. 准备项目目录

```bash
# 进入项目目录
cd /home/kali/repo/

# 如果项目在 Git 仓库中，可以克隆
# git clone <repository-url> Resources
```

### 2. 配置环境变量

```bash
# 复制环境变量模板
cp .example.env .env

# 编辑 .env 文件，设置所有必要的配置
# 至少需要设置：
# - 所有 *_PASSWORD 变量
# - 所有 *_PORT 变量（如果需要自定义端口）
# - 所有 *_DATA_PATH 变量（如果需要自定义数据路径）
nano .env  # 或使用您喜欢的编辑器
```

### 3. 启动服务

```bash
# 启动所有服务（后台运行）
docker compose --env-file .env up -d

# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f
```

### 4. 验证部署

```bash
# 检查所有容器是否运行
docker compose ps

# 应该看到所有服务状态为 "Up"
```

访问各个管理界面验证服务是否正常：

- MySQL UI (phpMyAdmin): `http://<your-ip>:${MYSQL_UI_PORT}` (默认 10101)
- PostgreSQL UI (pgAdmin): `http://<your-ip>:${POSTGRESQL_UI_PORT}` (默认 10106)
- MongoDB UI (Mongo Express): `http://<your-ip>:${MONGO_UI_PORT}` (默认 10111)
- Redis UI (RedisInsight): `http://<your-ip>:${REDIS_UI_PORT}` (默认 10121)
- Kafka UI: `http://<your-ip>:${KAFKA_UI_PORT}` (默认 10131)

> **注意**：请将 `<your-ip>` 替换为您的实际主机 IP 地址。

## 生产环境部署

### 安全配置

1. **更改默认密码**
   - 确保所有 `*_PASSWORD` 变量使用强密码
   - 建议使用密码生成器生成随机密码

2. **网络安全**
   - 仅在内网或受信任的网络中开放端口
   - 使用防火墙限制访问来源
   - 考虑使用 VPN 进行远程访问

3. **数据备份**
   - 定期备份 `Databases/` 目录
   - 配置自动备份脚本
   - 将备份存储到安全位置
   - 建议使用版本化的备份策略（保留多个时间点的备份）

### 性能优化

1. **资源限制**
   在 `docker-compose.yml` 中为每个服务添加资源限制：

```yaml
services:
  mysql:
    # ... 其他配置 ...
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '1'
          memory: 1G
```

2. **数据目录优化**
   - 将数据目录放在高性能存储上（SSD）
   - 考虑使用 Docker 卷而不是绑定挂载

3. **日志管理**
   配置日志轮转以防止磁盘空间耗尽：

```yaml
services:
  mysql:
    # ... 其他配置 ...
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### 高可用性（可选）

对于生产环境，可以考虑：

1. **数据库主从复制**
   - MySQL 主从复制
   - PostgreSQL 流复制
   - MongoDB 副本集

2. **Kafka 集群**
   - 部署多节点 Kafka 集群
   - 配置副本和分区策略

3. **负载均衡**
   - 使用 Nginx 或 Traefik 进行负载均衡
   - 配置健康检查

## 维护操作

### 停止服务

```bash
# 进入项目目录
cd /home/kali/repo/

# 停止所有服务（保留数据）
docker compose --env-file .env stop

# 停止并删除容器（保留数据）
docker compose --env-file .env down
```

### 重启服务

```bash
# 进入项目目录
cd /home/kali/repo/

# 重启所有服务
docker compose --env-file .env restart

# 重启特定服务
docker compose --env-file .env restart mysql
```

### 更新服务

```bash
# 进入项目目录
cd /home/kali/repo/

# 拉取最新镜像
docker compose --env-file .env pull

# 重新创建并启动容器
docker compose --env-file .env up -d
```

### 查看日志

```bash
# 进入项目目录
cd /home/kali/repo/

# 查看所有服务日志
docker compose --env-file .env logs -f

# 查看特定服务日志
docker compose --env-file .env logs -f mysql

# 查看最近 100 行日志
docker compose --env-file .env logs --tail 100 mysql

# 查看带时间戳的日志
docker compose --env-file .env logs -f -t mysql
```

### 数据备份

```bash
# 进入项目目录
cd /home/kali/repo/

# 创建备份目录
mkdir -p backups/$(date +%Y%m%d)

# 备份 MySQL
docker compose --env-file .env exec mysql mysqldump -u root -p${MYSQL_ROOT_PASSWORD} --all-databases > backups/$(date +%Y%m%d)/mysql-backup.sql

# 备份 PostgreSQL
docker compose --env-file .env exec postgresql pg_dumpall -U ${POSTGRESQL_ROOT_USERNAME} > backups/$(date +%Y%m%d)/postgresql-backup.sql

# 备份 MongoDB
docker compose --env-file .env exec mongodb mongodump --out /backup
docker compose --env-file .env cp mongodb:/backup backups/$(date +%Y%m%d)/mongodb-backup

# 备份 Redis
docker compose --env-file .env exec redis redis-cli -a ${REDIS_PASSWORD} --rdb /data/dump.rdb
docker compose --env-file .env cp redis:/data/dump.rdb backups/$(date +%Y%m%d)/redis-dump.rdb

# 备份 Kafka 数据（直接备份数据目录）
tar -czf backups/$(date +%Y%m%d)/kafka-backup.tar.gz Databases/kafka/
```

### 数据恢复

```bash
# 进入项目目录
cd /home/kali/repo/

# 恢复 MySQL
docker compose --env-file .env exec -T mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} < backups/YYYYMMDD/mysql-backup.sql

# 恢复 PostgreSQL
docker compose --env-file .env exec -T postgresql psql -U ${POSTGRESQL_ROOT_USERNAME} < backups/YYYYMMDD/postgresql-backup.sql

# 恢复 MongoDB
docker compose --env-file .env cp backups/YYYYMMDD/mongodb-backup mongodb:/backup
docker compose --env-file .env exec mongodb mongorestore /backup

# 恢复 Redis
docker compose --env-file .env cp backups/YYYYMMDD/redis-dump.rdb redis:/data/dump.rdb
# 需要重启 Redis 容器使备份生效
docker compose --env-file .env restart redis

# 恢复 Kafka 数据
tar -xzf backups/YYYYMMDD/kafka-backup.tar.gz -C Databases/
# 需要重启 Kafka 容器
docker compose --env-file .env restart kafka
```

> **注意**：请将 `YYYYMMDD` 替换为实际的备份日期。

## 故障排查

### 容器无法启动

1. 检查日志：
```bash
docker compose logs <service-name>
```

2. 检查端口冲突：
```bash
netstat -tulpn | grep <port>
```

3. 检查磁盘空间：
```bash
df -h
```

### 服务无法连接

1. 检查网络：
```bash
docker network inspect nfx-stack
```

2. 检查容器状态：
```bash
docker compose ps
```

3. 测试连接：
```bash
docker compose exec mysql mysql -u root -p
```

### 性能问题

1. 检查资源使用：
```bash
docker stats
```

2. 检查日志中的错误信息
3. 考虑增加资源限制或优化配置

## 卸载

```bash
# 进入项目目录
cd /home/kali/repo/

# 停止并删除所有容器和网络（保留数据）
docker compose --env-file .env down

# 删除所有数据（谨慎操作！）
# 请确保已备份重要数据
sudo rm -rf Databases/

# 删除镜像（可选）
docker compose --env-file .env down --rmi all

# 删除网络（如果存在）
docker network rm nfx-stack
```

---

## 支持

**开发者**：Lucas Lyu  
**联系方式**：lyulucas2003@gmail.com

