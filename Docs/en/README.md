# NFX-Stack Docs Usage Guide / How-To

`dev.toml`、`prod.toml` are configuration templates that can be directly copied into new services, covering MySQL, Redis, Kafka, MongoDB, MinIO. All default values are aligned with `Resources/.env`; you only need to replace credentials and project-specific names.

[中文版本](../README.md)

## Workflow

1. **Copy templates**  
   Place them in the project's `configs/` or `cmd/<service>/config/`. Adjust `mysql.dbname`, Kafka Topic, MinIO Bucket according to the service name.

2. **Replace secrets**  
   Search for `<...>` / `REPLACE_WITH_*` and fill in the actual values maintained in NFX-Stack `.env` (`MYSQL_ROOT_PASSWORD`, `REDIS_PASSWORD`, `MONGO_ROOT_PASSWORD`, `MINIO_ROOT_USER`, etc.). When independent accounts are needed, create them in the public instance first, then write them in.

3. **Choose endpoints**  
   - **Containers in `nfx-stack` network**: Keep internal addresses like `host = "mysql"`, `endpoint = "http://minio:9000"`.  
   - **Outside NAS / Local debugging**: Change host/port to `192.168.1.64:<EXTERNAL_PORT>`. The main README document has a complete port table.

4. **Toggle modules**  
   Services that don't need Mongo or MinIO can delete the corresponding sections; if new services are needed (e.g., ElasticSearch), add `[elasticsearch]` following the existing structure.

## MinIO Deep Dive

The template includes a complete `[minio]` block:

```
[minio]
endpoint = "http://minio:9000"
# optional: for business use in LAN/local debugging; can be deleted if not needed
external_endpoint = "http://192.168.1.64:${MINIO_API_PORT}"
# optional: only for outputting management address
console_url = "http://192.168.1.64:${MINIO_CONSOLE_PORT}"
access_key = "<MINIO_ACCESS_KEY>"
secret_key = "<MINIO_SECRET_KEY>"
bucket = "<PRIMARY_BUCKET>"
region = "<MINIO_REGION>"   # MinIO defaults to us-east-1, can be customized freely if needed
secure = false
create_bucket_on_start = true
```

- **endpoint / external_endpoint**: Correspond to container-internal and LAN access respectively. Choose one based on deployment environment.  
- **secure**: Set to `true` if MinIO enables HTTPS and certificates are trusted; keep `false` for self-signed certificates.  
- **create_bucket_on_start**: Automatically create Bucket when the application starts; can be disabled in production.  
- **console_url**: Convenient for outputting clickable Console addresses in logs or health checks.

> It is recommended to use independent MinIO Bucket + Access Key for each project. If multiple buckets are needed, replace `bucket` with a custom structure (e.g., `buckets = ["raw","processed"]`), with permission control configured in Console Policy.

## Default Endpoints

| Service | Internal Address (Same Network) | Host Access (LAN) | Notes |
|---------|--------------------------------|-------------------|-------|
| MySQL | `mysql:3306` | `192.168.1.64:10013` (`MYSQL_DATABASE_PORT`) | Can be reused after adjusting `dbname`, `user`. |
| Redis | `redis:6379` | `192.168.1.64:10015` (`REDIS_DATABASE_PORT`) | Remember to fill in `REDIS_PASSWORD`. |
| Kafka | `kafka:9092` | `192.168.1.64:10109` (`KAFKA_EXTERNAL_PORT`) | `nfx_stack_public` cluster. |
| MongoDB | `mongodb:27017` | `192.168.1.64:10014` (`MONGO_DATABASE_PORT`) | Default `authSource = admin`. |
| MinIO S3 | `minio:9000` | `192.168.1.64:${MINIO_API_PORT}` | Console: `${MINIO_CONSOLE_PORT}`. |

> Reminder: Access outside LAN must go through VPN / firewall; or add IP allowlist and Basic Auth at the service layer.

## Best Practices

- Create independent databases, Redis DBs, Kafka Topics, MinIO Buckets for each project.  
- When including TOML in the repository, inject sensitive information using `.env`, Vault, K8s Secret.  
- After changing NFX-Stack ports/credentials, update templates immediately and notify the project team to avoid configuration drift.  
- When additional services are needed (SMTP, ElasticSearch, etc.), declare them in `Resources/docker-compose.yml` first, then extend the templates.

Copy → Replace → Run, and all backend services will be aligned with the same infrastructure configuration. Happy hacking!

---

## Support

**Developer**: Lucas Lyu  
**Contact**: lyulucas2003@gmail.com
