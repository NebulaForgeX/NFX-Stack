# NFX Stack

> ⚠️ **重要提示**：使用本仓库前，请先阅读 [NFX-Policy](https://github.com/NebulaForgeX/NFX-Policy)，了解部署和配置的重要注意事项。

**NFX Stack = NebulaForgeX Resource Stack**

**统一资源与基础设施平台，面向现代开发**

<div align="center">
  <img src="image.png" alt="NFX Stack Logo" width="200">
  
  [English Documentation](Docs/en/README.md) | [配置文档](Docs/README.md) | [部署指南](Docs/DEPLOYMENT.md) | [项目结构](Docs/STRUCTURE.md)
</div>

NFX Stack 是 NebulaForgeX 生态系统的基础设施层，提供了一个完全模块化、生产级资源栈，专为快速应用开发、本地环境一致性和云原生微服务架构而设计。

通过单一、可扩展的基于 Docker 的平台，NFX Stack 打包并编排所有必需的后端服务——数据库、消息系统、缓存层及其管理界面，使开发者能够在几分钟内启动一个完整、完全集成的环境。

## 核心特性

### 🗄️ 统一资源层
提供 MySQL、PostgreSQL、MongoDB、Redis、Kafka 等预配置的生产级数据库和消息队列服务，所有服务均经过生产级加固。

### 🛠️ 开发者优化
所有服务通过 Docker Compose 统一编排，确保确定性环境和零设置摩擦，支持一键启动和停止。

### 🖥️ 内置管理界面
每个服务都配备了对应的 Web 管理界面：
- **phpMyAdmin** - MySQL 数据库管理
- **pgAdmin** - PostgreSQL 数据库管理
- **Mongo Express** - MongoDB 数据库管理
- **RedisInsight** - Redis 缓存管理
- **Kafka UI** - Kafka 消息队列管理

### 🏗️ 微服务就绪架构
设计为 NebulaForgeX 生态系统的基础设施层，为所有微服务提供统一的数据存储和消息队列服务。

### 🔌 可扩展和模块化
采用模块化设计，可以轻松添加或删除服务，适合具有多样化后端需求的不断增长的生态系统。

### ☁️ 云原生实践
遵循现代 SaaS 平台的最佳实践：隔离的 Docker 网络、持久化数据卷和统一的环境变量配置。

## 用途

NFX Stack 作为所有 NebulaForgeX 项目的骨干，提供：

- 共享的开发环境
- 跨服务的标准化资源栈
- 领域驱动架构的可靠基础
- 数据基础设施的单一真实来源
- 新微服务和实验项目的启动平台

无论您是在构建身份认证、内容管道、爬虫、市场系统还是 AI 驱动的服务，NFX Stack 都能确保您的基础设施一致、可预测且随时可用。

---

> **注意**：如果您调整 `.env`，请同步本文档中的主机端口；所有 `*_PORT`、`*_USERNAME`、`*_PASSWORD` 值均取自该文件。

## 快速开始

```bash
cd /volume1/Resources

# 1. 启动服务
docker compose --env-file .env up -d

# 2. 检查状态
docker compose ps

# 3. 停止并清理
docker compose down
```

- 默认网络：`nfx-stack`；业务容器可以加入此网络，通过名称访问服务（例如 `mysql:3306`）。
- 对于物理机/本地访问，请使用下表中的主机端口，并确保防火墙允许访问。

## 服务列表

### 数据库服务

| 服务 | 容器名 | 镜像 | 数据端口 | UI 端口 | 说明 |
|------|--------|------|---------|---------|------|
| **MySQL** | `NFX-Stack-MySQL` | `mysql:8.0` | `${MYSQL_DATABASE_PORT}` (默认 10013) | `${MYSQL_UI_PORT}` (默认 10101) | 关系型数据库，支持 UTF8MB4 |
| **PostgreSQL** | `NFX-Stack-PostgreSQL` | `postgres:15-alpine` | `${POSTGRESQL_DATABASE_PORT}` (默认 10016) | `${POSTGRESQL_UI_PORT}` (默认 10106) | 关系型数据库 |
| **MongoDB** | `NFX-Stack-MongoDB` | `mongo:4.4` | `${MONGO_DATABASE_PORT}` (默认 10014) | `${MONGO_UI_PORT}` (默认 10111) | 文档数据库 |
| **Redis** | `NFX-Stack-Redis` | `redis:7-alpine` | `${REDIS_DATABASE_PORT}` (默认 10015) | `${REDIS_UI_PORT}` (默认 10121) | 内存缓存数据库 |

### 消息队列服务

| 服务 | 容器名 | 镜像 | 外部端口 | UI 端口 | 说明 |
|------|--------|------|---------|---------|------|
| **Kafka** | `NFX-Stack-Kafka` | `apache/kafka:latest` | `${KAFKA_EXTERNAL_PORT}` (默认 10109) | `${KAFKA_UI_PORT}` (默认 10131) | 分布式消息队列（KRaft 模式） |

### 对象存储服务（可选）

| 服务 | 容器名 | 镜像 | API 端口 | Console 端口 | 说明 |
|------|--------|------|---------|-------------|------|
| **MinIO** | `NFX-Stack-MinIO` | `minio/minio:RELEASE.*` | `${MINIO_API_PORT}` | `${MINIO_UI_PORT}` | S3 兼容对象存储（默认已注释，需要时取消注释） |

## UI 和管理仪表板访问

| 管理界面 | 访问 URL | 登录凭据 | 说明 |
|---------|---------|---------|------|
| **phpMyAdmin** | `http://<your-ip>:${MYSQL_UI_PORT}` (默认 10101) | MySQL root 密码 (`MYSQL_ROOT_PASSWORD`) | 服务器地址输入 `mysql`（同网络）或 `<your-ip>` |
| **pgAdmin** | `http://<your-ip>:${POSTGRESQL_UI_PORT}` (默认 10106) | 邮箱/密码 (`POSTGRESQL_UI_USERNAME` / `POSTGRESQL_UI_PASSWORD`) | 首次登录后需要添加服务器连接 |
| **Mongo Express** | `http://<your-ip>:${MONGO_UI_PORT}` (默认 10111) | Basic Auth (`MONGO_UI_USERNAME` / `MONGO_UI_PASSWORD`)，然后使用 Mongo Root (`MONGO_ROOT_USERNAME` / `MONGO_ROOT_PASSWORD`) | 建议修改 Basic Auth 以防止未授权访问 |
| **RedisInsight** | `http://<your-ip>:${REDIS_UI_PORT}` (默认 10121) | 可选（如设置了 `RI_USERNAME/RI_PASSWORD`） | 首次使用需要创建工作区，连接 Redis 时输入 `redis:6379` 或 `<your-ip>:${REDIS_DATABASE_PORT}` |
| **Kafka UI** | `http://<your-ip>:${KAFKA_UI_PORT}` (默认 10131) | 无（可配置 Basic Auth） | 预配置集群 `nfx_stack_public`，Bootstrap Servers: `kafka:9092` |
| **MinIO Console** | `http://<your-ip>:${MINIO_UI_PORT}` | `MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD` | S3 API: `http://<your-ip>:${MINIO_API_PORT}` |

## 连接字符串示例

### 容器内访问（同网络）

当业务服务加入 `nfx-stack` 网络时，可以使用容器名访问：

```bash
# MySQL
mysql://root:${MYSQL_ROOT_PASSWORD}@mysql:3306/dbname

# PostgreSQL
postgresql://${POSTGRESQL_ROOT_USERNAME}:${POSTGRESQL_ROOT_PASSWORD}@postgresql:5432/dbname

# MongoDB
mongodb://${MONGO_ROOT_USERNAME}:${MONGO_ROOT_PASSWORD}@mongodb:27017/dbname?authSource=admin

# Redis
redis://:${REDIS_PASSWORD}@redis:6379/0

# Kafka
PLAINTEXT://kafka:9092
```

### 宿主机访问（LAN/本地）

从宿主机或局域网访问时，使用主机 IP 和映射端口：

```bash
# MySQL
mysql://root:${MYSQL_ROOT_PASSWORD}@<your-ip>:${MYSQL_DATABASE_PORT}/dbname

# PostgreSQL
postgresql://${POSTGRESQL_ROOT_USERNAME}:${POSTGRESQL_ROOT_PASSWORD}@<your-ip>:${POSTGRESQL_DATABASE_PORT}/dbname

# MongoDB
mongodb://${MONGO_ROOT_USERNAME}:${MONGO_ROOT_PASSWORD}@<your-ip>:${MONGO_DATABASE_PORT}/dbname?authSource=admin

# Redis
redis://:${REDIS_PASSWORD}@<your-ip>:${REDIS_DATABASE_PORT}/0

# Kafka
PLAINTEXT://<your-ip>:${KAFKA_EXTERNAL_PORT}

# MinIO S3 API
http://<your-ip>:${MINIO_API_PORT}
```

> **安全提示**  
> - 仅在受信任的网络上开放端口；建议使用防火墙限制访问来源  
> - 修改端口后，请同步更新 `Docs/dev.toml` 和 `Docs/prod.toml` 配置模板  
> - 生产环境建议使用强密码并定期更换

## MinIO 对象存储（可选）

MinIO 在 `docker-compose.yml` 中默认被注释，需要使用时请取消注释。

### 功能说明

- **API 端口** (`MINIO_API_PORT`): 提供 S3 兼容的对象存储接口
- **Console 端口** (`MINIO_UI_PORT`): Web 管理控制台，用于管理用户、存储桶和访问策略

### 配置示例

业务服务配置示例（完整配置见 `Docs/dev.toml`）：

```toml
[minio]
endpoint = "http://minio:9000"        # 容器内访问
external_endpoint = "http://<your-ip>:${MINIO_API_PORT}"  # 外部访问
access_key = "${MINIO_ROOT_USER}"
secret_key = "${MINIO_ROOT_PASSWORD}"
region = "us-east-1"
bucket = "<PROJECT_BUCKET>"
secure = false  # 使用 HTTPS 时设为 true
```

### 最佳实践

- 为每个项目创建独立的存储桶
- 在 Console 中为每个项目配置独立的访问密钥（Access Key / Secret Key）
- 使用最小权限原则配置访问策略

## 配置模板

`Docs/` 目录提供了开发和生产环境的配置模板：

- **`dev.toml`** - 开发环境配置模板
- **`prod.toml`** - 生产环境配置模板

这些模板包含所有服务的连接配置（MySQL、PostgreSQL、MongoDB、Redis、Kafka、MinIO），可以直接复制到业务服务中使用。

### 使用步骤

1. **复制模板**  
   将 `dev.toml` 或 `prod.toml` 复制到项目的 `config/` 或 `configs/` 目录

2. **替换占位符**  
   搜索并替换所有 `<...>` 和 `REPLACE_WITH_*` 占位符：
   - 数据库名称、用户名、密码
   - Kafka Topic 名称
   - MinIO Bucket 名称

3. **选择访问方式**  
   - **容器内访问**：保持 `host = "mysql"` 等容器名
   - **外部访问**：改为 `<your-ip>:<port>` 格式

4. **按需启用/禁用**  
   不需要的服务（如 MongoDB、MinIO）可以删除对应配置段

详细使用说明请参考 [配置文档使用指南](Docs/README.md)。

---

## 文档导航

- **[配置文档使用指南](Docs/README.md)** - 配置模板使用说明
- **[项目结构](Docs/STRUCTURE.md)** - 详细的目录结构和服务说明
- **[部署指南](Docs/DEPLOYMENT.md)** - 部署步骤和最佳实践
- **[配置详解](Docs/CONFIGURATION.md)** - 所有配置选项的详细说明
- **[文档索引](Docs/INDEX.md)** - 完整文档导航

## 支持

如果您在使用 NFX Stack 时遇到问题或有建议，欢迎通过以下方式联系：

- 发送邮件：lyulucas2003@gmail.com
- 提交 Issue（如果项目托管在代码仓库中）

**开发者**：Lucas Lyu  
**联系方式**：lyulucas2003@gmail.com
