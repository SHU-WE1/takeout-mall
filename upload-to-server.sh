#!/bin/bash

# 上传项目到服务器的脚本
# 使用方法: ./upload-to-server.sh

set -e

SERVER_IP="167.179.78.66"
SERVER_USER="root"
SERVER_PATH="/root/takeout-mall"
LOCAL_PATH="/Users/weishu/Desktop/takeout mall"

echo "=========================================="
echo "开始上传项目到服务器..."
echo "=========================================="

# 检查本地路径
if [ ! -d "$LOCAL_PATH" ]; then
    echo "错误: 本地路径不存在: $LOCAL_PATH"
    exit 1
fi

# 使用 rsync 上传文件（排除不需要的文件）
echo "正在上传项目文件..."
rsync -avz --progress \
    --exclude 'node_modules' \
    --exclude 'target' \
    --exclude '.git' \
    --exclude '.idea' \
    --exclude '*.log' \
    --exclude 'dist' \
    --exclude 'build' \
    --exclude '.DS_Store' \
    --exclude '*.swp' \
    --exclude '*.swo' \
    "$LOCAL_PATH/" "$SERVER_USER@$SERVER_IP:$SERVER_PATH/"

echo "=========================================="
echo "文件上传完成！"
echo "=========================================="
echo "下一步："
echo "1. SSH 连接到服务器: ssh $SERVER_USER@$SERVER_IP"
echo "2. 进入项目目录: cd $SERVER_PATH"
echo "3. 运行初始化脚本: ./server-setup.sh"
echo "4. 运行部署脚本: ./deploy.sh"
echo ""
echo "注意: 微信支付证书文件可以稍后上传（可选）"
echo "=========================================="

