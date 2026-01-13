# NFX Stack 配置详解

本文档详细说明 NFX Stack 的所有配置选项。

[English Version](en/CONFIGURATION.md)

## 配置文件

NFX Stack 使用 `.env` 文件进行配置。所有配置项都通过环境变量传递给 Docker 容器。

### 创建配置文件

```bash
# 从模板复制
cp .example.env .env

# 编辑配置文件
nano .env
```

## 配置分类

### MySQL 配置

```bash
# MySQL 根用户（默认不能更改）
MYSQL_ROOT_USERNAME=root

# MySQL 根密码（必须设置）
MYSQL_ROOT_PASSWORD=<YOUR_MYSQL_ROOT_PASSWORD>

# MySQL 数据库端口绑定 IP
MYSQL_DATABASE_HOST=0.0.0.0  # 0.0.0.0 表示所有接口，127.0.0.1 表示仅本地

# MySQL 数据库端口
MYSQL_DATABASE_PORT=10013

# MySQL UI 端口绑定 IP
MYSQL_UI_HOST=0.0.0.0

# MySQL UI 端口
MYSQL_UI_PORT=10101

# MySQL 数据目录（默认：/volume1/NFX-Stack/Databases/mysql）
MYSQL_DATA_PATH=/home/kali/repo/Databases/mysql

# MySQL 初始化脚本目录（默认：/volume1/NFX-Stack/Databases/mysql-init）
MYSQL_INIT_PATH=/home/kali/repo/Databases/mysql-init
```

### PostgreSQL 配置

```bash
# PostgreSQL 根用户名
POSTGRESQL_ROOT_USERNAME=postgres

# PostgreSQL 根密码
POSTGRESQL_ROOT_PASSWORD=<YOUR_POSTGRESQL_ROOT_PASSWORD>

# PostgreSQL 数据库端口绑定 IP
POSTGRESQL_DATABASE_HOST=0.0.0.0

# PostgreSQL 数据库端口
POSTGRESQL_DATABASE_PORT=10016

# PostgreSQL UI 端口绑定 IP
POSTGRESQL_UI_HOST=0.0.0.0

# PostgreSQL UI 端口
POSTGRESQL_UI_PORT=10106

# PostgreSQL UI 用户名（邮箱格式）
POSTGRESQL_UI_USERNAME=admin@admin.com

# PostgreSQL UI 密码
POSTGRESQL_UI_PASSWORD=<YOUR_POSTGRESQL_UI_PASSWORD>

# PostgreSQL 数据目录（默认：/volume1/NFX-Stack/Databases/postgresql）
POSTGRESQL_DATA_PATH=/home/kali/repo/Databases/postgresql

# PostgreSQL 初始化脚本目录（默认：/volume1/NFX-Stack/Databases/postgresql-init）
POSTGRESQL_INIT_PATH=/home/kali/repo/Databases/postgresql-init
```

### MongoDB 配置

```bash
# MongoDB 根用户名
MONGO_ROOT_USERNAME=<YOUR_MONGO_ROOT_USERNAME>

# MongoDB 根密码
MONGO_ROOT_PASSWORD=<YOUR_MONGO_ROOT_PASSWORD>

# MongoDB 数据库端口绑定 IP
MONGO_DATABASE_HOST=0.0.0.0

# MongoDB 数据库端口
MONGO_DATABASE_PORT=10014

# MongoDB UI 用户名（Basic Auth）
MONGO_UI_USERNAME=<YOUR_MONGO_UI_USERNAME>

# MongoDB UI 密码（Basic Auth）
MONGO_UI_PASSWORD=<YOUR_MONGO_UI_PASSWORD>

# MongoDB UI 端口绑定 IP
MONGO_UI_HOST=0.0.0.0

# MongoDB UI 端口
MONGO_UI_PORT=10111

# MongoDB 数据目录（默认：/volume1/NFX-Stack/Databases/mongodb）
MONGO_DATA_PATH=/home/kali/repo/Databases/mongodb

# MongoDB 初始化脚本目录（默认：/volume1/NFX-Stack/Databases/mongodb-init）
MONGO_INIT_PATH=/home/kali/repo/Databases/mongodb-init
```

### Redis 配置

```bash
# Redis 密码
REDIS_PASSWORD=<YOUR_REDIS_PASSWORD>

# Redis 数据库端口绑定 IP
REDIS_DATABASE_HOST=0.0.0.0

# Redis 数据库端口
REDIS_DATABASE_PORT=10015

# Redis UI 端口绑定 IP
REDIS_UI_HOST=0.0.0.0

# Redis UI 端口
REDIS_UI_PORT=10121

# Redis 数据目录（默认：/volume1/NFX-Stack/Databases/redis）
REDIS_DATA_PATH=/home/kali/repo/Databases/redis
```

### Kafka 配置

```bash
# Kafka 内部使用的 IP（用于 ADVERTISED_LISTENERS）
KAFKA_INTERNAL_HOST_IP=192.168.1.64

# Kafka 外部端口绑定 IP
KAFKA_EXTERNAL_HOST=0.0.0.0

# Kafka 外部端口
KAFKA_EXTERNAL_PORT=10109

# Kafka UI 端口绑定 IP
KAFKA_UI_HOST=0.0.0.0

# Kafka UI 端口
KAFKA_UI_PORT=10131

# Kafka 数据目录（默认：/volume1/NFX-Stack/Databases/kafka）
KAFKA_DATA_PATH=/home/kali/repo/Databases/kafka

# Kafka 内部使用的 IP（用于 ADVERTISED_LISTENERS，通常是宿主机 IP）
KAFKA_INTERNAL_HOST_IP=192.168.1.64
```

### MinIO 配置（可选）

```bash
# MinIO 根用户
MINIO_ROOT_USER=<YOUR_MINIO_ROOT_USER>

# MinIO 根密码
MINIO_ROOT_PASSWORD=<YOUR_MINIO_ROOT_PASSWORD>

# MinIO API 端口绑定 IP
MINIO_API_HOST=0.0.0.0

# MinIO API 端口（S3 兼容接口）
MINIO_API_PORT=10141

# MinIO UI 端口绑定 IP
MINIO_UI_HOST=0.0.0.0

# MinIO UI 端口（管理控制台）
MINIO_UI_PORT=10142

# MinIO 数据目录（默认：/volume1/NFX-Stack/Stores）
MINIO_DATA_PATH=/home/kali/repo//Stores
```

## 端口配置说明

### 默认端口分配

| 服务 | 数据端口 | UI 端口 | 说明 |
|------|---------|---------|------|
| MySQL | 10013 | 10101 | 数据库和 phpMyAdmin |
| PostgreSQL | 10016 | 10106 | 数据库和 pgAdmin |
| MongoDB | 10014 | 10111 | 数据库和 Mongo Express |
| Redis | 10015 | 10121 | 数据库和 RedisInsight |
| Kafka | 10109 | 10131 | 消息队列和 Kafka UI |
| MinIO | 10141 | 10142 | S3 API 和管理控制台 |

### 端口冲突处理

如果默认端口已被占用，可以修改 `.env` 文件中的相应端口配置。

**注意**：修改端口后，需要同步更新：
1. `Docs/dev.toml` 和 `Docs/prod.toml` 中的端口配置
2. 业务服务的配置文件
3. 防火墙规则

## 网络配置

### 绑定 IP 说明

- `0.0.0.0`：绑定所有网络接口，允许从任何 IP 访问
- `127.0.0.1`：仅绑定本地回环接口，只能从本机访问
- `192.168.1.64`：绑定特定 IP，只能从该 IP 访问

### 安全建议

- **开发环境**：可以使用 `0.0.0.0` 方便调试
- **生产环境**：建议使用特定 IP 或 `127.0.0.1`，并通过防火墙限制访问

## 数据目录配置

### 路径说明

所有数据目录都通过环境变量配置，支持绝对路径和相对路径：

- **绝对路径**：`/home/kali/repo/Databases/mysql`
- **相对路径**：`./Databases/mysql`（相对于 docker-compose.yml 所在目录）

### 权限要求

确保 Docker 有权限访问数据目录：

```bash
# 创建目录
mkdir -p Databases/mysql Databases/mongodb Databases/postgresql Databases/redis Databases/kafka

# 设置权限（如果需要）
sudo chown -R $USER:$USER Databases/
```

## 初始化脚本

### MySQL 初始化

将 SQL 脚本放在 `MYSQL_INIT_PATH` 目录中，容器启动时会自动执行：

```bash
# 创建初始化脚本目录
mkdir -p Databases/mysql-init

# 添加初始化脚本
echo "CREATE DATABASE IF NOT EXISTS myapp;" > Databases/mysql-init/init.sql
```

### PostgreSQL 初始化

将 SQL 脚本放在 `POSTGRESQL_INIT_PATH` 目录中：

```bash
mkdir -p Databases/postgresql-init
echo "CREATE DATABASE myapp;" > Databases/postgresql-init/init.sql
```

### MongoDB 初始化

将 JavaScript 脚本放在 `MONGO_INIT_PATH` 目录中：

```bash
mkdir -p Databases/mongodb-init
echo "db.createUser({user: 'myuser', pwd: 'mypass', roles: ['readWrite']})" > Databases/mongodb-init/init.js
```

## 配置验证

### 检查配置

```bash
# 验证环境变量是否正确加载
docker compose config

# 检查特定服务的配置
docker compose config mysql
```

### 测试连接

```bash
# 测试 MySQL
docker compose exec mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SELECT 1"

# 测试 PostgreSQL
docker compose exec postgresql psql -U ${POSTGRESQL_ROOT_USERNAME} -c "SELECT 1"

# 测试 Redis
docker compose exec redis redis-cli -a ${REDIS_PASSWORD} ping

# 测试 MongoDB
docker compose exec mongodb mongo -u ${MONGO_ROOT_USERNAME} -p${MONGO_ROOT_PASSWORD} --eval "db.adminCommand('ping')"
```

## 配置模板

`Docs/` 目录提供了配置模板：

- **dev.toml**：开发环境配置模板
- **prod.toml**：生产环境配置模板

这些模板可以直接复制到业务服务中使用，只需替换占位符即可。

详细使用方法请参考 [README.md](README.md)。

---

## 支持

**开发者**：Lucas Lyu  
**联系方式**：lyulucas2003@gmail.com

