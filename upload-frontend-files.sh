#!/bin/bash

# 上传修改的前端文件到服务器
# 使用方法: ./upload-frontend-files.sh
# 注意: 执行时会提示输入服务器密码

set -e

SERVER_IP="167.179.78.66"
SERVER_USER="root"
SERVER_PATH="/root/takeout-mall"

echo "=========================================="
echo "开始上传修改的前端文件到服务器..."
echo "=========================================="
echo "注意: 系统会提示输入服务器密码，请输入密码后按回车"
echo "=========================================="
echo ""

# 上传文件
echo "1. 上传 orderList.vue..."
scp "frontend-admin/src/views/dashboard/components/orderList.vue" "$SERVER_USER@$SERVER_IP:$SERVER_PATH/frontend-admin/src/views/dashboard/components/"

echo "2. 上传 Empty/index.vue..."
scp "frontend-admin/src/components/Empty/index.vue" "$SERVER_USER@$SERVER_IP:$SERVER_PATH/frontend-admin/src/components/Empty/"

echo "3. 上传 inform/index.vue..."
scp "frontend-admin/src/views/inform/index.vue" "$SERVER_USER@$SERVER_IP:$SERVER_PATH/frontend-admin/src/views/inform/"

echo "4. 上传 Navbar/index.vue..."
scp "frontend-admin/src/layout/components/Navbar/index.vue" "$SERVER_USER@$SERVER_IP:$SERVER_PATH/frontend-admin/src/layout/components/Navbar/"

echo ""
echo "=========================================="
echo "文件上传完成！"
echo "=========================================="
echo "下一步："
echo "1. SSH 连接到服务器: ssh $SERVER_USER@$SERVER_IP"
echo "2. 进入项目目录: cd $SERVER_PATH"
echo "3. 运行前端更新脚本: ./update-frontend.sh"
echo "=========================================="







