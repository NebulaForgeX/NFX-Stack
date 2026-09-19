#!/usr/bin/env bash
# NFX-Stack 镜像内软件版本查看脚本（所有 docker 指令均通过 sudo 执行）

set -e

DOCKER="sudo docker"

echo "=============================================="
echo "  NFX-Stack 镜像版本检查"
echo "=============================================="
echo ""

echo "=== MySQL ==="
$DOCKER run --rm mysql:9.7.2 mysql --version 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

echo "=== MongoDB ==="
$DOCKER run --rm mongo:4.4 mongod --version 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

echo "=== PostgreSQL ==="
$DOCKER run --rm postgres:18.6 postgres --version 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

echo "=== Redis ==="
$DOCKER run --rm redis:8.8.2 redis-server --version 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

echo "=== RabbitMQ ==="
$DOCKER run --rm rabbitmq:4.3.5-management rabbitmqctl version 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

echo "=== Kafka ==="
$DOCKER image inspect apache/kafka:4.3.1 --format '  镜像: {{.RepoTags}}  创建: {{.Created}}' 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

echo "=============================================="
echo "  本机已拉取的 NFX-Stack 相关镜像"
echo "=============================================="
$DOCKER images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}\t{{.Size}}" \
  mysql mongo postgres redis rabbitmq phpmyadmin mongo-express dpage/pgadmin4 redis/redisinsight apache/kafka provectuslabs/kafka-ui centrifugo/centrifugo otel/opentelemetry-collector-contrib jaegertracing/jaeger prom/prometheus grafana/loki grafana/grafana opensearchproject/opensearch quay.io/minio/minio 2>/dev/null || true
echo ""
echo "完成。"
