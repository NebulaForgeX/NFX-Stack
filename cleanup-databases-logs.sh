#!/bin/bash
# 清理 Databases 和 logs 目录的脚本
# 使用方法: sudo ./cleanup-databases-logs.sh

echo "正在清理 Databases 和 logs 目录..."

# 停止所有容器（如果正在运行）
echo "检查并停止容器..."
docker-compose down 2>/dev/null || docker compose down 2>/dev/null || echo "容器可能已经停止"

# 删除 Databases 目录
if [ -d "Databases" ]; then
    echo "删除 Databases 目录..."
    sudo rm -rf Databases
    echo "✓ Databases 目录已删除"
else
    echo "Databases 目录不存在"
fi

# 删除 logs 目录
if [ -d "logs" ]; then
    echo "删除 logs 目录..."
    sudo rm -rf logs
    echo "✓ logs 目录已删除"
else
    echo "logs 目录不存在"
fi

echo ""
echo "清理完成！"
echo "现在可以重新创建这些目录（容器启动时会自动创建）："
echo "  mkdir -p Databases/{mysql,mongodb,postgresql,redis,rabbitmq,kafka}"
echo "  mkdir -p Logs/{mysql,mongodb,postgresql,redis,rabbitmq,kafka}"
