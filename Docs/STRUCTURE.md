# NFX Stack 项目结构

本文档详细说明 NFX Stack 项目的目录结构、服务架构和组织方式。

[English Version](en/STRUCTURE.md)

## 目录结构

```
Resources/
├── .env                    # 环境变量配置文件（从 .example.env 复制）
├── .example.env            # 环境变量配置模板
├── .gitignore             # Git 忽略文件
├── docker-compose.yml      # Docker Compose 配置文件
├── README.md               # 项目主文档（中文）
├── image.png               # 项目 Logo
├── Databases/              # 数据库数据持久化目录
│   ├── mysql/              # MySQL 数据目录
│   ├── mysql-init/         # MySQL 初始化脚本目录
│   ├── postgresql/         # PostgreSQL 数据目录
│   ├── postgresql-init/    # PostgreSQL 初始化脚本目录
│   ├── mongodb/            # MongoDB 数据目录
│   ├── mongodb-init/       # MongoDB 初始化脚本目录
│   ├── redis/              # Redis 数据目录
│   ├── kafka/              # Kafka 数据目录
│   └── pgadmin/            # pgAdmin 数据目录
├── Docs/                   # 文档目录
│   ├── README.md           # 配置文档使用说明（中文）
│   ├── STRUCTURE.md        # 项目结构文档（中文）
│   ├── DEPLOYMENT.md       # 部署指南（中文）
│   ├── CONFIGURATION.md    # 配置详解（中文）
│   ├── INDEX.md            # 文档索引（中文）
│   ├── dev.toml            # 开发环境配置模板
│   ├── prod.toml           # 生产环境配置模板
│   └── en/                 # 英文文档目录
│       ├── README.md
│       ├── STRUCTURE.md
│       ├── DEPLOYMENT.md
│       ├── CONFIGURATION.md
│       ├── INDEX.md
│       └── VIEW_UI_LOGS.md
└── Shared/                 # 共享资源目录（可选，当前为空）
```

## 核心组件

### Docker Compose 服务

NFX Stack 通过 `docker-compose.yml` 定义以下服务：

#### 数据库服务

##### 1. MySQL (`mysql`)

- **容器名**：`NFX-Stack-MySQL`
- **镜像**：`mysql:8.0`
- **数据目录**：`${MYSQL_DATA_PATH:-/volume1/NFX-Stack/Databases/mysql}`
- **初始化脚本目录**：`${MYSQL_INIT_PATH:-/volume1/NFX-Stack/Databases/mysql-init}`
- **数据端口**：`${MYSQL_DATABASE_PORT}` (默认 10013)
- **UI 端口**：`${MYSQL_UI_PORT}` (默认 10101)
- **特性**：
  - 字符集：UTF8MB4
  - 排序规则：utf8mb4_unicode_ci
  - 认证插件：mysql_native_password

##### 2. PostgreSQL (`postgresql`)

- **容器名**：`NFX-Stack-PostgreSQL`
- **镜像**：`postgres:15-alpine`
- **数据目录**：`${POSTGRESQL_DATA_PATH:-/volume1/NFX-Stack/Databases/postgresql}`
- **初始化脚本目录**：`${POSTGRESQL_INIT_PATH:-/volume1/NFX-Stack/Databases/postgresql-init}`
- **数据端口**：`${POSTGRESQL_DATABASE_PORT}` (默认 10016)
- **UI 端口**：`${POSTGRESQL_UI_PORT}` (默认 10106)
- **特性**：
  - 编码：UTF8
  - 区域设置：C

##### 3. MongoDB (`mongodb`)

- **容器名**：`NFX-Stack-MongoDB`
- **镜像**：`mongo:4.4`
- **数据目录**：`${MONGO_DATA_PATH:-/volume1/NFX-Stack/Databases/mongodb}`
- **初始化脚本目录**：`${MONGO_INIT_PATH:-/volume1/NFX-Stack/Databases/mongodb-init}`
- **数据端口**：`${MONGO_DATABASE_PORT}` (默认 10014)
- **UI 端口**：`${MONGO_UI_PORT}` (默认 10111)
- **特性**：
  - 支持 root 用户认证
  - 认证数据库：admin

##### 4. Redis (`redis`)

- **容器名**：`NFX-Stack-Redis`
- **镜像**：`redis:7-alpine`
- **数据目录**：`${REDIS_DATA_PATH:-/volume1/NFX-Stack/Databases/redis}`
- **数据端口**：`${REDIS_DATABASE_PORT}` (默认 10015)
- **UI 端口**：`${REDIS_UI_PORT}` (默认 10121)
- **特性**：
  - AOF 持久化：启用（每秒同步）
  - RDB 快照：60 秒内 1000 次变更
  - 最大内存：1GB
  - 内存淘汰策略：allkeys-lru
  - 密码保护：启用

#### 消息队列服务

##### 5. Kafka (`kafka`)

- **容器名**：`NFX-Stack-Kafka`
- **镜像**：`apache/kafka:latest`
- **数据目录**：`${KAFKA_DATA_PATH:-/volume1/NFX-Stack/Databases/kafka}`
- **外部端口**：`${KAFKA_EXTERNAL_PORT}` (默认 10109)
- **UI 端口**：`${KAFKA_UI_PORT}` (默认 10131)
- **特性**：
  - 运行模式：KRaft（单节点）
  - 节点角色：broker + controller
  - 内部端口：9092 (PLAINTEXT), 9093 (CONTROLLER), 9094 (EXTERNAL)
  - 自动创建主题：启用
  - 默认分区数：3
  - 副本因子：1（单节点）

#### 对象存储服务（可选）

##### 6. MinIO (`minio`) - 默认已注释

- **容器名**：`NFX-Stack-MinIO`
- **镜像**：`minio/minio:RELEASE.*`
- **数据目录**：`${MINIO_DATA_PATH:-/volume1/NFX-Stack/Stores}`
- **API 端口**：`${MINIO_API_PORT}` (默认 10141)
- **Console 端口**：`${MINIO_UI_PORT}` (默认 10142)
- **特性**：
  - S3 兼容 API
  - Web 管理控制台
  - Path-style 访问：启用
  - 需要使用时取消 `docker-compose.yml` 中的注释

#### 管理界面服务

##### 7. phpMyAdmin (`mysql-ui`)

- **容器名**：`NFX-Stack-MySQL-UI`
- **镜像**：`phpmyadmin:latest`
- **端口**：`${MYSQL_UI_PORT}` (默认 10101)
- **功能**：MySQL 数据库管理界面
- **特性**：
  - 支持任意服务器连接
  - 默认连接：`mysql:3306`

##### 8. pgAdmin (`postgresql-ui`)

- **容器名**：`NFX-Stack-PostgreSQL-UI`
- **镜像**：`dpage/pgadmin4:latest`
- **端口**：`${POSTGRESQL_UI_PORT}` (默认 10106)
- **功能**：PostgreSQL 数据库管理界面
- **特性**：
  - 单用户模式
  - 默认邮箱：`${POSTGRESQL_UI_USERNAME:-admin@admin.com}`

##### 9. Mongo Express (`mongodb-ui`)

- **容器名**：`NFX-Stack-MongoDB-UI`
- **镜像**：`mongo-express:latest`
- **端口**：`${MONGO_UI_PORT}` (默认 10111)
- **功能**：MongoDB 数据库管理界面
- **特性**：
  - Basic Auth 保护
  - 连接：`mongodb:27017`

##### 10. RedisInsight (`redis-ui`)

- **容器名**：`NFX-Stack-Redis-UI`
- **镜像**：`redis/redisinsight:latest`
- **端口**：`${REDIS_UI_PORT}` (默认 10121)
- **功能**：Redis 缓存管理界面
- **特性**：
  - 首次使用需要创建工作区
  - 连接：`redis:6379`

##### 11. Kafka UI (`kafka-ui`)

- **容器名**：`NFX-Stack-Kafka-UI`
- **镜像**：`provectuslabs/kafka-ui:latest`
- **端口**：`${KAFKA_UI_PORT}` (默认 10131)
- **功能**：Kafka 消息队列管理界面
- **特性**：
  - 预配置集群：`nfx_stack_public`
  - Bootstrap Servers：`kafka:9092`
  - 动态配置：启用

## 网络架构

### Docker 网络

- **网络名称**：`nfx-stack`
- **网络类型**：`bridge`
- **用途**：所有服务在同一网络中，可以通过容器名相互访问

### 服务间通信

#### 容器内访问（推荐）

当业务服务加入 `nfx-stack` 网络时，使用容器名访问：

```bash
mysql:3306              # MySQL
postgresql:5432         # PostgreSQL
mongodb:27017           # MongoDB
redis:6379              # Redis
kafka:9092              # Kafka
minio:9000              # MinIO API
```

#### 宿主机访问

从宿主机或局域网访问时，使用主机 IP 和映射端口：

```bash
<your-ip>:10013         # MySQL
<your-ip>:10016         # PostgreSQL
<your-ip>:10014         # MongoDB
<your-ip>:10015         # Redis
<your-ip>:10109         # Kafka
<your-ip>:${MINIO_API_PORT}  # MinIO API
```

## 数据持久化

所有数据库和存储服务的数据都持久化到 `Databases/` 目录下的相应子目录：

### 数据目录

- **MySQL**：`${MYSQL_DATA_PATH:-/volume1/NFX-Stack/Databases/mysql}`
- **PostgreSQL**：`${POSTGRESQL_DATA_PATH:-/volume1/NFX-Stack/Databases/postgresql}`
- **MongoDB**：`${MONGO_DATA_PATH:-/volume1/NFX-Stack/Databases/mongodb}`
- **Redis**：`${REDIS_DATA_PATH:-/volume1/NFX-Stack/Databases/redis}`
- **Kafka**：`${KAFKA_DATA_PATH:-/volume1/NFX-Stack/Databases/kafka}`
- **MinIO**：`${MINIO_DATA_PATH:-/volume1/NFX-Stack/Stores}`

### 初始化脚本目录

- **MySQL**：`${MYSQL_INIT_PATH:-/volume1/NFX-Stack/Databases/mysql-init}`
- **PostgreSQL**：`${POSTGRESQL_INIT_PATH:-/volume1/NFX-Stack/Databases/postgresql-init}`
- **MongoDB**：`${MONGO_INIT_PATH:-/volume1/NFX-Stack/Databases/mongodb-init}`

> **注意**：初始化脚本只在容器首次启动时执行，用于创建数据库、用户等。

### 数据持久化特性

- 数据在容器重启后保留
- 数据在容器删除后保留（除非手动删除数据目录）
- 支持数据备份和恢复
- 支持数据迁移

## 配置管理

### 环境变量文件

- **`.example.env`**：环境变量配置模板
- **`.env`**：实际使用的环境变量文件（从 `.example.env` 复制并修改）

### 配置模板

`Docs/` 目录提供配置模板：

- **`dev.toml`**：开发环境配置模板
- **`prod.toml`**：生产环境配置模板

这些模板包含所有服务的连接配置，可以直接复制到业务服务中使用。

### 配置分类

所有配置通过 `.env` 文件管理：

- **端口配置**：`*_PORT`、`*_HOST`
- **认证信息**：`*_PASSWORD`、`*_USERNAME`
- **数据路径**：`*_DATA_PATH`、`*_INIT_PATH`
- **网络绑定**：`*_HOST`（0.0.0.0 或特定 IP）

详细配置说明请参考 [CONFIGURATION.md](CONFIGURATION.md)。

## 服务依赖关系

```
mysql-ui ──┐
            ├──> mysql
postgresql-ui ──┐
                ├──> postgresql
mongodb-ui ──┐
             ├──> mongodb
redis-ui ──┐
           ├──> redis
kafka-ui ──┐
           ├──> kafka
```

所有 UI 服务都依赖于对应的数据服务，确保数据服务先启动。

## 扩展性

### 添加新服务

1. **在 `docker-compose.yml` 中添加服务定义**
   ```yaml
   new-service:
     image: new-service:latest
     container_name: NFX-Stack-NewService
     # ... 其他配置
     networks:
       - nfx-stack
   ```

2. **在 `.env` 中添加相应的环境变量**
   ```bash
   NEW_SERVICE_PORT=100XX
   NEW_SERVICE_PASSWORD=<password>
   # ...
   ```

3. **更新配置模板**
   - 在 `Docs/dev.toml` 中添加配置段
   - 在 `Docs/prod.toml` 中添加配置段

4. **更新文档**
   - 更新 `README.md`
   - 更新 `STRUCTURE.md`
   - 更新 `CONFIGURATION.md`

### 移除服务

1. **在 `docker-compose.yml` 中注释或删除服务定义**
   ```yaml
   # new-service:
   #   ...
   ```

2. **从 `.env` 中移除相关环境变量**（可选）

3. **从配置模板中移除相应配置段**（可选）

4. **更新文档**

### 启用 MinIO

MinIO 默认被注释，需要使用时：

1. 在 `docker-compose.yml` 中取消 MinIO 服务的注释
2. 在 `.env` 中配置 MinIO 相关环境变量
3. 重启服务：`docker compose up -d`

## 文件说明

### 核心文件

- **`docker-compose.yml`**：定义所有服务的配置和编排
- **`.env`**：环境变量配置（不纳入版本控制）
- **`.example.env`**：环境变量模板（纳入版本控制）

### 文档文件

- **`README.md`**：项目主文档，快速开始指南
- **`Docs/README.md`**：配置文档使用说明
- **`Docs/STRUCTURE.md`**：项目结构文档（本文档）
- **`Docs/DEPLOYMENT.md`**：部署指南
- **`Docs/CONFIGURATION.md`**：配置详解
- **`Docs/INDEX.md`**：文档索引

### 数据目录

- **`Databases/`**：所有数据库和存储服务的数据目录
- **`Shared/`**：共享资源目录（可选）

## 最佳实践

### 1. 数据备份

定期备份 `Databases/` 目录：

```bash
# 备份所有数据
tar -czf nfx-stack-backup-$(date +%Y%m%d).tar.gz Databases/

# 恢复数据
tar -xzf nfx-stack-backup-YYYYMMDD.tar.gz
```

### 2. 环境隔离

- 开发环境：可以使用默认配置
- 生产环境：使用强密码，限制网络访问

### 3. 资源管理

- 监控磁盘空间使用
- 定期清理日志文件
- 配置日志轮转

### 4. 安全配置

- 使用强密码
- 限制网络访问（防火墙）
- 定期更新镜像版本
- 使用最小权限原则

## 相关文档

- [配置文档使用指南](README.md) - 配置模板使用说明
- [部署指南](DEPLOYMENT.md) - 部署步骤和最佳实践
- [配置详解](CONFIGURATION.md) - 所有配置选项的详细说明
- [主项目 README](../README.md) - 项目介绍和快速开始

---

## 支持

**开发者**：Lucas Lyu  
**联系方式**：lyulucas2003@gmail.com
