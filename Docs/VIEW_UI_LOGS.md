# NFX Stack UI 服务日志查看指南

本文档介绍如何查看 NFX Stack 中各个 UI 管理服务的日志。

[English Version](en/VIEW_UI_LOGS.md)

## UI 服务列表

根据 `docker-compose.yml`，NFX Stack 提供以下 UI 管理服务：

1. **MySQL UI** (phpMyAdmin) - 容器：`NFX-Stack-MySQL-UI`
2. **MongoDB UI** (mongo-express) - 容器：`NFX-Stack-MongoDB-UI`
3. **PostgreSQL UI** (pgAdmin) - 容器：`NFX-Stack-PostgreSQL-UI`
4. **Redis UI** (RedisInsight) - 容器：`NFX-Stack-Redis-UI`
5. **Kafka UI** - 容器：`NFX-Stack-Kafka-UI`
6. **MinIO** (Web Console) - 容器：`NFX-Stack-MinIO`（可选，默认已注释）

## 查看日志的方法

### 方法 1：使用 `docker logs` 命令（推荐）

#### 查看单个 UI 服务的日志

```bash
# MySQL UI (phpMyAdmin)
docker logs NFX-Stack-MySQL-UI

# MongoDB UI (mongo-express)
docker logs NFX-Stack-MongoDB-UI

# PostgreSQL UI (pgAdmin)
docker logs NFX-Stack-PostgreSQL-UI

# Redis UI (RedisInsight)
docker logs NFX-Stack-Redis-UI

# Kafka UI
docker logs NFX-Stack-Kafka-UI

# MinIO (Web Console)
docker logs NFX-Stack-MinIO
```

#### 实时跟踪日志（类似 tail -f）

```bash
# 实时查看 MySQL UI 日志
docker logs -f NFX-Stack-MySQL-UI

# 实时查看 MongoDB UI 日志
docker logs -f NFX-Stack-MongoDB-UI

# 实时查看 PostgreSQL UI 日志
docker logs -f NFX-Stack-PostgreSQL-UI

# 实时查看 Redis UI 日志
docker logs -f NFX-Stack-Redis-UI

# 实时查看 Kafka UI 日志
docker logs -f NFX-Stack-Kafka-UI

# 实时查看 MinIO 日志
docker logs -f NFX-Stack-MinIO
```

#### 查看最近的日志（最后 N 行）

```bash
# 查看最后 100 行
docker logs --tail 100 NFX-Stack-MySQL-UI

# 查看最后 50 行并实时跟踪
docker logs --tail 50 -f NFX-Stack-MongoDB-UI
```

#### 查看带时间戳的日志

```bash
# 显示时间戳
docker logs -t NFX-Stack-PostgreSQL-UI

# 实时跟踪并显示时间戳
docker logs -f -t NFX-Stack-Redis-UI
```

#### 查看特定时间范围的日志

```bash
# 查看最近 10 分钟的日志
docker logs --since 10m NFX-Stack-Kafka-UI

# 查看最近 1 小时的日志
docker logs --since 1h NFX-Stack-MinIO

# 查看从特定时间点开始的日志
docker logs --since "2025-01-20T10:00:00" NFX-Stack-MySQL-UI

# 查看特定时间范围内的日志
docker logs --since "2025-01-20T10:00:00" --until "2025-01-20T11:00:00" NFX-Stack-MongoDB-UI
```

### 方法 2：使用 `docker compose logs` 命令（推荐）

在 `/volume1/Resources` 目录下执行：

```bash
cd /volume1/Resources

# 查看所有 UI 服务的日志
docker compose --env-file .env logs mysql-ui mongodb-ui postgresql-ui redis-ui kafka-ui

# 查看单个 UI 服务的日志
docker compose --env-file .env logs mysql-ui
docker compose --env-file .env logs mongodb-ui
docker compose --env-file .env logs postgresql-ui
docker compose --env-file .env logs redis-ui
docker compose --env-file .env logs kafka-ui

# 实时跟踪所有 UI 服务的日志
docker compose --env-file .env logs -f mysql-ui mongodb-ui postgresql-ui redis-ui kafka-ui

# 查看最后 100 行
docker compose --env-file .env logs --tail 100 mysql-ui

# 查看带时间戳的日志
docker compose --env-file .env logs -t mysql-ui
```

### 方法 3：一键查看所有 UI 服务日志

```bash
# 查看所有 NFX Stack UI 服务的日志
docker logs NFX-Stack-MySQL-UI NFX-Stack-MongoDB-UI NFX-Stack-PostgreSQL-UI NFX-Stack-Redis-UI NFX-Stack-Kafka-UI NFX-Stack-MinIO

# 实时跟踪所有 UI 服务的日志
docker logs -f NFX-Stack-MySQL-UI NFX-Stack-MongoDB-UI NFX-Stack-PostgreSQL-UI NFX-Stack-Redis-UI NFX-Stack-Kafka-UI NFX-Stack-MinIO
```

### 方法 4：使用脚本批量查看

创建一个脚本文件 `view-ui-logs.sh`：

```bash
#!/bin/bash

echo "=== NFX Stack UI 服务日志查看器 ==="
echo ""
echo "1. MySQL UI (phpMyAdmin)"
echo "2. MongoDB UI (mongo-express)"
echo "3. PostgreSQL UI (pgAdmin)"
echo "4. Redis UI (RedisInsight)"
echo "5. Kafka UI"
echo "6. MinIO"
echo "7. 查看所有 UI 服务日志"
echo "0. 退出"
echo ""

read -p "请选择服务 (0-7): " choice

case $choice in
    1)
        docker logs -f NFX-Stack-MySQL-UI
        ;;
    2)
        docker logs -f NFX-Stack-MongoDB-UI
        ;;
    3)
        docker logs -f NFX-Stack-PostgreSQL-UI
        ;;
    4)
        docker logs -f NFX-Stack-Redis-UI
        ;;
    5)
        docker logs -f NFX-Stack-Kafka-UI
        ;;
    6)
        docker logs -f NFX-Stack-MinIO
        ;;
    7)
        echo "正在查看所有 UI 服务日志..."
        docker logs -f NFX-Stack-MySQL-UI NFX-Stack-MongoDB-UI NFX-Stack-PostgreSQL-UI NFX-Stack-Redis-UI NFX-Stack-Kafka-UI NFX-Stack-MinIO
        ;;
    0)
        exit 0
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac
```

使用脚本：

```bash
# 添加执行权限
chmod +x view-ui-logs.sh

# 运行脚本
./view-ui-logs.sh
```

## 常用命令组合

### 查看错误日志

```bash
# 查看包含 "error" 的日志
docker logs NFX-Stack-MySQL-UI 2>&1 | grep -i error

# 查看包含 "error" 或 "warn" 的日志
docker logs NFX-Stack-MongoDB-UI 2>&1 | grep -iE "error|warn"
```

### 导出日志到文件

```bash
# 导出 MySQL UI 日志到文件
docker logs NFX-Stack-MySQL-UI > mysql-ui.log 2>&1

# 导出所有 UI 服务日志
docker logs NFX-Stack-MySQL-UI > mysql-ui.log 2>&1
docker logs NFX-Stack-MongoDB-UI > mongodb-ui.log 2>&1
docker logs NFX-Stack-PostgreSQL-UI > postgresql-ui.log 2>&1
docker logs NFX-Stack-Redis-UI > redis-ui.log 2>&1
docker logs NFX-Stack-Kafka-UI > kafka-ui.log 2>&1
docker logs NFX-Stack-MinIO > minio.log 2>&1
```

### 查看容器状态和日志

```bash
# 首先检查容器状态
docker ps --filter "name=NFX-Stack" --format "table {{.Names}}\t{{.Status}}"

# 然后查看对应容器的日志
docker logs -f <container-name>
```

## 注意事项

1. **权限**：某些系统可能需要 `sudo` 权限来执行 Docker 命令
2. **命令格式**：使用 `docker compose`（Docker Compose V2）而不是 `docker-compose`
3. **日志大小**：Docker 日志可能占用大量磁盘空间；建议定期清理或配置日志轮转
4. **实时跟踪**：使用 `-f` 参数时，按 `Ctrl+C` 退出实时跟踪
5. **日志限制**：Docker 默认限制日志大小；可以在 `docker-compose.yml` 中配置日志驱动和大小限制

## 配置日志限制（可选）

在 `docker-compose.yml` 中为服务添加日志配置：

```yaml
services:
  mysql-ui:
    # ... 其他配置 ...
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

这将限制每个日志文件最大为 10MB，并保留最多 3 个文件。

## 故障排查

### 容器未运行

如果无法查看日志，首先检查容器是否运行：

```bash
# 检查所有 NFX Stack 容器状态
docker ps --filter "name=NFX-Stack"

# 如果容器未运行，启动服务
cd /volume1/Resources
docker compose --env-file .env up -d
```

### 日志为空

如果日志为空，可能是：

1. 容器刚启动，还没有产生日志
2. 日志被清空或轮转
3. 容器配置了日志驱动但没有输出

### 权限问题

如果遇到权限问题：

```bash
# 使用 sudo（如果需要）
sudo docker logs NFX-Stack-MySQL-UI

# 或者将用户添加到 docker 组
sudo usermod -aG docker $USER
# 然后重新登录
```

## 相关文档

- [部署指南](DEPLOYMENT.md) - 了解如何部署和维护服务
- [配置详解](CONFIGURATION.md) - 了解如何配置日志
- [项目结构](STRUCTURE.md) - 了解项目结构

---

## 支持

**开发者**：Lucas Lyu  
**联系方式**：lyulucas2003@gmail.com

