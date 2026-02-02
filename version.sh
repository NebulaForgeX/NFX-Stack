#!/usr/bin/env bash
# NFX-Stack 镜像内软件版本查看脚本（所有 docker 指令均通过 sudo 执行）

set -e

DOCKER="sudo docker"

echo "=============================================="
echo "  NFX-Stack 镜像版本检查"
echo "=============================================="
echo ""

# MySQL
echo "=== MySQL ==="
$DOCKER run --rm mysql:latest mysql --version 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

# MongoDB（compose 当前为 4.4，无 AVX 机器用此版本）
echo "=== MongoDB ==="
$DOCKER run --rm mongo:4.4 mongod --version 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

# PostgreSQL
echo "=== PostgreSQL ==="
$DOCKER run --rm postgres:latest postgres --version 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

# Redis
echo "=== Redis ==="
$DOCKER run --rm redis:latest redis-server --version 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

# RabbitMQ
echo "=== RabbitMQ ==="
$DOCKER run --rm rabbitmq:latest rabbitmqctl version 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

# Kafka（镜像内无统一 version 命令，仅校验镜像存在）
echo "=== Kafka ==="
$DOCKER image inspect apache/kafka:latest --format '  镜像: {{.RepoTags}}  创建: {{.Created}}' 2>/dev/null || echo "  (镜像未拉取或执行失败)"
echo ""

echo "=============================================="
echo "  本机已拉取的 NFX-Stack 相关镜像"
echo "=============================================="
$DOCKER images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}\t{{.Size}}" \
  mysql mongo postgres redis rabbitmq phpmyadmin mongo-express dpage/pgadmin4 redis/redisinsight apache/kafka provectuslabs/kafka-ui 2>/dev/null || true
echo ""
echo "完成。"