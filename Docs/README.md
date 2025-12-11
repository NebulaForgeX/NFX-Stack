# NFX-Stack Docs 使用说明 / How-To

`dev.toml`、`prod.toml` 是可以直接复制到新服务中的配置模板，覆盖 MySQL、Redis、Kafka、MongoDB、MinIO。所有默认值已经与 `NFX-Stack/.env` 对齐，只需替换凭证和业务专属名称即可。

## 使用步骤 / Workflow

1. **复制模板 Copy templates**  
   放入项目的 `configs/` 或 `cmd/<service>/config/`。根据服务名称调整 `mysql.dbname`、Kafka Topic、MinIO Bucket。

2. **更新凭证 Replace secrets**  
   搜索 `<...>` / `REPLACE_WITH_*`，逐一填入 NFX-Stack `.env` 中维护的真实值（`MYSQL_ROOT_PASSWORD`、`REDIS_PASSWORD`、`MONGO_ROOT_PASSWORD`、`MINIO_ROOT_USER` 等）。需要独立账号时，先在公共实例创建再写入。

3. **选择访问域 Choose endpoints**  
   - **容器在 `nfx-stack` 网络**：保持 `host = "mysql"`、`endpoint = "http://minio:9000"` 等内部地址。  
   - **NAS 以外 / 本地调试**：将 host/port 改成 `192.168.1.64:<EXTERNAL_PORT>`。README 主文档有完整端口表。

4. **启用/禁用模块 Toggle modules**  
   不需要 Mongo、MinIO 的服务可以删除对应段落；如需新服务（例如 ElasticSearch），可仿照现有结构追加 `[elasticsearch]`。

## MinIO 配置详解 / MinIO Deep Dive

模板中新增了完整 `[minio]` 区块，涵盖：

```
[minio]
endpoint = "http://minio:9000"
# optional: 业务在 LAN/本地调试时用；没有需求可删除
external_endpoint = "http://192.168.1.64:${MINIO_API_PORT}"
# optional: 仅用于输出管理地址
console_url = "http://192.168.1.64:${MINIO_CONSOLE_PORT}"
access_key = "<MINIO_ACCESS_KEY>"
secret_key = "<MINIO_SECRET_KEY>"
bucket = "<PRIMARY_BUCKET>"
region = "<MINIO_REGION>"   # MinIO 默认 us-east-1，如需自定义可自由填写
secure = false
create_bucket_on_start = true
```

- **endpoint / external_endpoint**：分别对应容器内与 LAN 访问。根据部署环境选择其一。  
- **secure**：若 MinIO 启用 HTTPS 且证书受信，设为 `true`；自签证书可保持 `false`。  
- **create_bucket_on_start**：应用启动时自动创建 Bucket，可在生产禁用。  
- **console_url**：便于在日志或健康检查中输出可点击的 Console 地址。

> 每个项目建议使用独立的 MinIO Bucket + Access Key。若需要多个桶，可将 `bucket` 换成自定义结构（例如 `buckets = ["raw","processed"]`），权限控制在 Console Policy 中配置。

## 默认端口 / Default Endpoints

| 服务 | 内部地址（同网络） | 宿主机访问 (LAN) | 说明 |
|------|--------------------|------------------|------|
| MySQL | `mysql:3306` | `192.168.1.64:10013` (`MYSQL_DATABASE_PORT`) | 调整 `dbname`、`user` 后即可复用。 |
| Redis | `redis:6379` | `192.168.1.64:10015` (`REDIS_DATABASE_PORT`) | 记得填写 `REDIS_PASSWORD`。 |
| Kafka | `kafka:9092` | `192.168.1.64:10109` (`KAFKA_EXTERNAL_PORT`) | `nfx_stack_public` 集群。 |
| MongoDB | `mongodb:27017` | `192.168.1.64:10014` (`MONGO_DATABASE_PORT`) | 默认 `authSource = admin`。 |
| MinIO S3 | `minio:9000` | `192.168.1.64:${MINIO_API_PORT}` | Console: `${MINIO_CONSOLE_PORT}`。 |

> 提醒 Reminder：LAN 以外访问必须通过 VPN / 防火墙；或在服务层增加 IP allowlist 与 Basic Auth。

## 最佳实践 / Best Practices

- 为每个项目创建独立的数据库、Redis DB、Kafka Topic、MinIO Bucket。  
- 将 TOML 纳入仓库时，敏感信息使用 `.env`、Vault、K8s Secret 注入。  
- 变更 NFX-Stack 端口/凭证后，立即更新模板并通知项目组，避免配置漂移。  
- 需要额外服务（SMTP、ElasticSearch 等）时，先在 `NFX-Stack/docker-compose.yml` 中声明，再扩展模板。

复制 → 替换 → 运行，即可保证所有后端服务对齐同一套基础设施配置。Happy hacking!

