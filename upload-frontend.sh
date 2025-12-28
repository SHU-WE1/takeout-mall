#!/bin/bash

# 上传前端文件到服务器的脚本
# 使用方法: ./upload-frontend.sh

set -e

SERVER_IP="167.179.78.66"
SERVER_USER="root"
SERVER_PATH="/root/takeout-mall"
LOCAL_PATH="/Users/weishu/Desktop/takeout mall"

echo "=========================================="
echo "开始上传前端文件到服务器..."
echo "=========================================="

# 检查本地路径
if [ ! -d "$LOCAL_PATH/frontend-admin" ]; then
    echo "错误: 本地前端路径不存在: $LOCAL_PATH/frontend-admin"
    exit 1
fi

# 使用 rsync 上传前端文件（只上传修改的文件）
echo "正在上传前端文件..."
rsync -avz --progress \
    --exclude 'node_modules' \
    --exclude 'dist' \
    --exclude 'build' \
    --exclude '.git' \
    --exclude '.idea' \
    --exclude '*.log' \
    --exclude '.DS_Store' \
    --exclude '*.swp' \
    --exclude '*.swo' \
    --exclude 'coverage' \
    --exclude '.cache' \
    "$LOCAL_PATH/frontend-admin/" "$SERVER_USER@$SERVER_IP:$SERVER_PATH/frontend-admin/"

echo "=========================================="
echo "前端文件上传完成！"
echo "=========================================="
echo "下一步："
echo "1. SSH 连接到服务器: ssh $SERVER_USER@$SERVER_IP"
echo "2. 进入项目目录: cd $SERVER_PATH"
echo "3. 运行前端更新脚本: ./update-frontend.sh"
echo "=========================================="







