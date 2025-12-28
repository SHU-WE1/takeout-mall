#!/bin/bash

# 前端服务更新脚本
# 用于在服务器上拉取最新代码并重新部署前端服务

set -e

echo "=========================================="
echo "开始更新前端服务..."
echo "=========================================="

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

# 检查 Docker 和 Docker Compose
if ! command -v docker &> /dev/null; then
    echo "错误: Docker 未安装"
    exit 1
fi

if ! docker compose version &> /dev/null; then
    echo "错误: Docker Compose 未安装"
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

# 进入项目目录（如果不在项目目录）
cd /root/takeout-mall || {
    echo "错误: 无法进入项目目录 /root/takeout-mall"
    exit 1
}

# 步骤 1: 拉取最新代码
echo "步骤 1: 从 Git 拉取最新代码..."
if [ -d ".git" ]; then
    git pull origin main || git pull origin master || {
        echo "警告: Git 拉取失败，继续使用当前代码..."
    }
else
    echo "警告: 当前目录不是 Git 仓库，跳过 Git 拉取"
fi

# 步骤 2: 停止前端服务
echo "步骤 2: 停止前端服务..."
docker compose -f docker-compose.prod.yml --env-file .env.prod stop frontend || true

# 步骤 3: 重新构建前端镜像
echo "步骤 3: 重新构建前端镜像..."
echo "注意: 前端构建可能需要几分钟时间，请耐心等待..."
docker compose -f docker-compose.prod.yml --env-file .env.prod build --no-cache frontend

# 步骤 4: 启动前端服务
echo "步骤 4: 启动前端服务..."
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d frontend

# 步骤 5: 等待服务启动
echo "步骤 5: 等待服务启动..."
sleep 10

# 步骤 6: 检查服务状态
echo "步骤 6: 检查服务状态..."
docker compose -f docker-compose.prod.yml --env-file .env.prod ps frontend

# 步骤 7: 显示前端服务日志
echo "=========================================="
echo "前端服务日志（最近50行）..."
echo "=========================================="
docker compose -f docker-compose.prod.yml --env-file .env.prod logs --tail=50 frontend

echo "=========================================="
echo "前端服务更新完成！"
echo "=========================================="
echo "服务访问地址："
echo "  - 前端管理页面: http://$(hostname -I | awk '{print $1}')"
echo "=========================================="
echo "常用命令："
echo "  查看日志: docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f frontend"
echo "  查看状态: docker compose -f docker-compose.prod.yml --env-file .env.prod ps frontend"
echo "  重启服务: docker compose -f docker-compose.prod.yml --env-file .env.prod restart frontend"
echo "=========================================="







