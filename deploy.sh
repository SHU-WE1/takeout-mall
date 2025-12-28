#!/bin/bash

# 项目部署脚本
# 用于在服务器上部署项目

set -e

echo "=========================================="
echo "开始部署项目..."
echo "=========================================="

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

# 检查 Docker 和 Docker Compose
if ! command -v docker &> /dev/null; then
    echo "错误: Docker 未安装，请先运行 server-setup.sh"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "错误: Docker Compose 未安装，请先运行 server-setup.sh"
    exit 1
fi

# 检查必要文件
if [ ! -f "docker-compose.prod.yml" ]; then
    echo "错误: docker-compose.prod.yml 文件不存在"
    exit 1
fi

if [ ! -f ".env.prod" ]; then
    echo "错误: .env.prod 文件不存在"
    exit 1
fi

if [ ! -d "certs" ]; then
    echo "警告: certs 目录不存在，正在创建..."
    mkdir -p certs
fi

# 检查证书文件（可选，不影响部署）
CERT_MISSING=false
if [ ! -f "certs/apiclient_key.pem" ]; then
    CERT_MISSING=true
fi

if ! ls certs/wechatpay_*.pem 1> /dev/null 2>&1; then
    CERT_MISSING=true
fi

if [ "$CERT_MISSING" = true ]; then
    echo "⚠️  警告: 微信支付证书文件缺失，部署将继续进行"
    echo "   如果需要使用微信支付功能，请稍后上传证书文件到 certs/ 目录："
    echo "     - certs/apiclient_key.pem"
    echo "     - certs/wechatpay_*.pem"
    echo "   上传后重启后端服务即可生效"
    echo ""
fi

# 停止现有容器
echo "正在停止现有容器..."
docker compose -f docker-compose.prod.yml --env-file .env.prod down || true

# 构建镜像
echo "正在构建 Docker 镜像..."
docker compose -f docker-compose.prod.yml --env-file .env.prod build --no-cache

# 启动服务
echo "正在启动服务..."
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d

# 等待服务启动
echo "等待服务启动..."
sleep 10

# 检查服务状态
echo "检查服务状态..."
docker compose -f docker-compose.prod.yml --env-file .env.prod ps

# 显示日志
echo "=========================================="
echo "查看服务日志（最近50行）..."
echo "=========================================="
docker compose -f docker-compose.prod.yml --env-file .env.prod logs --tail=50

echo "=========================================="
echo "部署完成！"
echo "=========================================="
echo "服务访问地址："
echo "  - 前端: http://$(hostname -I | awk '{print $1}')"
echo "  - 后端API: http://$(hostname -I | awk '{print $1}'):8080"
echo "=========================================="
echo "常用命令："
echo "  查看日志: docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f"
echo "  停止服务: docker compose -f docker-compose.prod.yml --env-file .env.prod down"
echo "  重启服务: docker compose -f docker-compose.prod.yml --env-file .env.prod restart"
echo "  查看状态: docker compose -f docker-compose.prod.yml --env-file .env.prod ps"
echo "=========================================="

