# NFX Stack 配置文档使用说明

`dev.toml` 和 `prod.toml` 是可以直接复制到新服务中使用的配置模板，涵盖了 MySQL、PostgreSQL、MongoDB、Redis、Kafka、MinIO 等所有服务的连接配置。所有默认值已经与 `Resources/.env` 对齐，只需替换凭证和项目特定的名称即可。

[English Version](en/README.md)

## 快速开始

### 1. 复制模板

将配置模板复制到您的项目目录：

```bash
# 开发环境
cp /home/kali/repo//Docs/dev.toml /path/to/your/project/configs/dev.toml

# 生产环境
cp /home/kali/repo//Docs/prod.toml /path/to/your/project/configs/prod.toml
```

建议放置位置：
- `configs/dev.toml` / `configs/prod.toml`
- `cmd/<service>/config/dev.toml` / `cmd/<service>/config/prod.toml`
- `config/dev.toml` / `config/prod.toml`

### 2. 替换占位符

搜索并替换所有 `<...>` 和 `REPLACE_WITH_*` 占位符：

| 占位符 | 说明 | 来源 |
|--------|------|------|
| `<MYSQL_ROOT_PASSWORD>` | MySQL root 密码 | `.env` 中的 `MYSQL_ROOT_PASSWORD` |
| `<MYSQL_DATABASE_NAME>` | 项目数据库名 | 项目特定，如 `myapp_db` |
| `<POSTGRES_ROOT_PASSWORD>` | PostgreSQL root 密码 | `.env` 中的 `POSTGRESQL_ROOT_PASSWORD` |
| `<POSTGRES_DATABASE_NAME>` | 项目数据库名 | 项目特定 |
| `<REDIS_PASSWORD>` | Redis 密码 | `.env` 中的 `REDIS_PASSWORD` |
| `<MONGO_ROOT_USERNAME>` | MongoDB root 用户名 | `.env` 中的 `MONGO_ROOT_USERNAME` |
| `<MONGO_ROOT_PASSWORD>` | MongoDB root 密码 | `.env` 中的 `MONGO_ROOT_PASSWORD` |
| `<MONGO_DATABASE>` | 项目数据库名 | 项目特定 |
| `<MINIO_ACCESS_KEY>` | MinIO 访问密钥 | `.env` 中的 `MINIO_ROOT_USER` 或自定义 |
| `<MINIO_SECRET_KEY>` | MinIO 密钥 | `.env` 中的 `MINIO_ROOT_PASSWORD` 或自定义 |
| `<PRIMARY_BUCKET>` | MinIO 存储桶名 | 项目特定 |

### 3. 选择访问方式

根据您的部署环境选择访问方式：

#### 容器内访问（推荐）

当业务服务加入 `nfx-stack` Docker 网络时，使用容器名访问：

```toml
[mysql]
host = "mysql"        # 容器名
port = 3306           # 内部端口

[postgresql]
host = "postgresql"   # 容器名
port = 5432

[cache]
host = "redis"        # 容器名
port = 6379

[kafka]
brokers = ["kafka:9092"]  # 容器名

[mongodb]
host = "mongodb"      # 容器名
port = 27017

[minio]
endpoint = "http://minio:9000"  # 容器名
```

#### 外部访问（宿主机/LAN）

从宿主机或局域网访问时，使用主机 IP 和映射端口：

```toml
[mysql]
host = "192.168.1.64"           # 主机 IP
port = 10013                     # MYSQL_DATABASE_PORT

[postgresql]
host = "192.168.1.64"
port = 10016                     # POSTGRESQL_DATABASE_PORT

[cache]
host = "192.168.1.64"
port = 10015                     # REDIS_DATABASE_PORT

[kafka]
brokers = ["192.168.1.64:10109"]  # KAFKA_EXTERNAL_PORT

[mongodb]
host = "192.168.1.64"
port = 10014                     # MONGO_DATABASE_PORT

[minio]
endpoint = "http://192.168.1.64:${MINIO_API_PORT}"
external_endpoint = "http://192.168.1.64:${MINIO_API_PORT}"
```

> **注意**：请将 `192.168.1.64` 替换为您的实际主机 IP 地址。

### 4. 按需启用/禁用服务

不需要的服务可以删除对应的配置段：

```toml
# 如果不需要 MongoDB，删除整个 [mongodb] 段
# [mongodb]
#   ...

# 如果不需要 MinIO，删除整个 [minio] 段
# [minio]
#   ...
```

## 配置详解

### MySQL 配置

```toml
[mysql]
host = "mysql"                    # 或 "192.168.1.64"
port = 3306                       # 或 10013（外部访问）
user = "root"                     # 或业务账户
password = "<MYSQL_ROOT_PASSWORD>"
dbname = "<MYSQL_DATABASE_NAME>"  # 项目数据库名
charset = "utf8mb4"
parse_time = true
loc = "Local"
logger_level = "warn"             # 开发环境 "warn"，生产环境 "error"
auto_migrate = false              # 是否自动迁移数据库

[mysql.connection]
timeout = "5s"
max_retries = 5
retry_interval = "2s"
max_idle_connections = 10
max_open_connections = 100
conn_max_idle_time = "15m"
conn_max_lifetime = "1h"
```

### PostgreSQL 配置

```toml
[postgresql]
host = "postgresql"               # 或 "192.168.1.64"
port = 5432                       # 或 10016（外部访问）
user = "postgres"                 # 或业务账户
password = "<POSTGRES_ROOT_PASSWORD>"
dbname = "<POSTGRES_DATABASE_NAME>"
sslmode = "disable"
timezone = "UTC"
logger_level = "warn"
auto_migrate = false

[postgresql.connection]
timeout = "5s"
max_retries = 5
retry_interval = "2s"
max_idle_connections = 10
max_open_connections = 100
conn_max_idle_time = "15m"
conn_max_lifetime = "1h"
```

### Redis 配置

```toml
[cache]
host = "redis"                    # 或 "192.168.1.64"
port = 6379                       # 或 10015（外部访问）
password = "<REDIS_PASSWORD>"
db = 0                            # 开发环境通常用 0，生产环境建议用 1

[cache.connection]
dial_timeout = "3s"
write_timeout = "3s"
read_timeout = "3s"
max_retries = 5
retry_interval = "2s"
```

### Kafka 配置

```toml
[kafka]
brokers = ["kafka:9092"]          # 或 ["192.168.1.64:10109"]
client_id = "your-service-name"   # 项目特定客户端 ID

[kafka.network]
max_open_requests = 1

[kafka.producer]
acks = "all"                       # 消息确认级别
compression = "snappy"            # 压缩算法
retries = 3
batch_bytes = 1048576
linger_ms = 5
idempotent = true

[kafka.consumer]
group_id = "your-service-group"   # 消费者组 ID
initial_offset = "latest"         # 或 "earliest"
session_timeout_ms = 10000
heartbeat_interval_ms = 3000
fetch_min_bytes = 1
fetch_max_bytes = 5242880

# 生产者主题（发布事件）
[kafka.producer_topics]
your_topic = "your.namespace.topic"

# 消费者主题（监听事件）
[kafka.consumer_topics]
your_topic = "your.namespace.topic"

[kafka.security]
enabled = false                   # 生产环境可启用
mechanism = "PLAIN"
username = ""
password = ""
tls_insecure_skip_verify = false
```

### MongoDB 配置

```toml
[mongodb]
host = "mongodb"                  # 或 "192.168.1.64"
port = 27017                      # 或 10014（外部访问）
username = "<MONGO_ROOT_USERNAME>"
password = "<MONGO_ROOT_PASSWORD>"
database = "<MONGO_DATABASE>"     # 项目数据库名
auth_source = "admin"             # 认证数据库
```

### MinIO 配置

```toml
[minio]
# 容器内访问地址
endpoint = "http://minio:9000"
# 外部访问地址（可选，LAN/本地调试时使用）
external_endpoint = "http://192.168.1.64:${MINIO_API_PORT}"
# 管理控制台地址（可选，仅用于输出管理地址）
console_url = "http://192.168.1.64:${MINIO_UI_PORT}"
# 访问密钥
access_key = "<MINIO_ACCESS_KEY>"
# 密钥
secret_key = "<MINIO_SECRET_KEY>"
# 存储桶名称
bucket = "<PRIMARY_BUCKET>"
# 区域（MinIO 默认 us-east-1，可自定义）
region = "us-east-1"
# 是否使用 HTTPS（启用 HTTPS 且证书受信时设为 true）
secure = false
# 应用启动时自动创建存储桶（生产环境建议禁用）
create_bucket_on_start = true
```

**MinIO 配置说明**：

- **endpoint / external_endpoint**：分别对应容器内与 LAN 访问，根据部署环境选择其一
- **secure**：若 MinIO 启用 HTTPS 且证书受信，设为 `true`；自签证书保持 `false`
- **create_bucket_on_start**：应用启动时自动创建 Bucket，生产环境建议禁用
- **console_url**：便于在日志或健康检查中输出可点击的 Console 地址

> **最佳实践**：每个项目建议使用独立的 MinIO Bucket + Access Key。若需要多个桶，可将 `bucket` 换成自定义结构（例如 `buckets = ["raw","processed"]`），权限控制在 Console Policy 中配置。

## 默认端口参考

| 服务 | 内部地址（同网络） | 宿主机访问 (LAN) | 环境变量 |
|------|--------------------|------------------|----------|
| MySQL | `mysql:3306` | `<your-ip>:10013` | `MYSQL_DATABASE_PORT` |
| PostgreSQL | `postgresql:5432` | `<your-ip>:10016` | `POSTGRESQL_DATABASE_PORT` |
| MongoDB | `mongodb:27017` | `<your-ip>:10014` | `MONGO_DATABASE_PORT` |
| Redis | `redis:6379` | `<your-ip>:10015` | `REDIS_DATABASE_PORT` |
| Kafka | `kafka:9092` | `<your-ip>:10109` | `KAFKA_EXTERNAL_PORT` |
| MinIO S3 API | `minio:9000` | `<your-ip>:${MINIO_API_PORT}` | `MINIO_API_PORT` |
| MinIO Console | - | `<your-ip>:${MINIO_UI_PORT}` | `MINIO_UI_PORT` |

> **安全提醒**：LAN 以外访问必须通过 VPN / 防火墙；或在服务层增加 IP allowlist 与 Basic Auth。

## 最佳实践

### 1. 资源隔离

- 为每个项目创建独立的数据库、Redis DB、Kafka Topic、MinIO Bucket
- 避免多个项目共享同一资源，便于管理和维护

### 2. 敏感信息管理

- 将 TOML 纳入仓库时，敏感信息使用环境变量注入
- 使用 `.env`、Vault、K8s Secret 等工具管理密码和密钥
- 不要在代码仓库中硬编码密码

### 3. 配置同步

- 变更 NFX-Stack 端口/凭证后，立即更新模板并通知项目组
- 避免配置漂移，保持所有服务配置一致

### 4. 扩展服务

- 需要额外服务（SMTP、ElasticSearch 等）时，先在 `Resources/docker-compose.yml` 中声明
- 然后扩展 `dev.toml` 和 `prod.toml` 模板
- 更新相关文档

### 5. 环境区分

- 开发环境：可以使用更宽松的配置，便于调试
- 生产环境：使用严格的配置，启用安全选项，限制连接数等

## 故障排查

### 连接失败

1. **检查服务是否运行**
   ```bash
   docker compose ps
   ```

2. **检查网络连接**
   ```bash
   # 测试容器内连接
   docker compose exec <your-service> ping mysql
   
   # 测试外部连接
   telnet <your-ip> 10013
   ```

3. **检查端口映射**
   ```bash
   docker compose config | grep -A 5 ports
   ```

4. **检查防火墙规则**
   ```bash
   sudo ufw status
   ```

### 认证失败

1. **验证密码是否正确**
   - 检查 `.env` 文件中的密码配置
   - 确认配置文件中使用的密码与 `.env` 一致

2. **检查用户权限**
   - MySQL/PostgreSQL：确认用户有访问数据库的权限
   - MongoDB：确认 `auth_source` 配置正确
   - Redis：确认密码配置正确

### 配置不生效

1. **检查配置文件路径**
   - 确认配置文件在正确的位置
   - 确认应用正确加载了配置文件

2. **检查环境变量**
   - 确认环境变量已正确设置
   - 检查是否有环境变量覆盖了配置文件

## 相关文档

- [项目结构](STRUCTURE.md) - 了解项目目录结构
- [部署指南](DEPLOYMENT.md) - 部署步骤和最佳实践
- [配置详解](CONFIGURATION.md) - 所有配置选项的详细说明
- [主项目 README](../README.md) - 项目介绍和快速开始

---

## 支持

**开发者**：Lucas Lyu  
**联系方式**：lyulucas2003@gmail.com
