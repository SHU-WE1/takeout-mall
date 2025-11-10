#!/bin/bash

# 服务器环境初始化脚本
# 用于在服务器上安装 Docker 和 Docker Compose

set -e

echo "=========================================="
echo "开始配置服务器环境..."
echo "=========================================="

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then 
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

# 更新系统包
echo "正在更新系统包..."
if command -v apt-get &> /dev/null; then
    apt-get update
    apt-get upgrade -y
elif command -v yum &> /dev/null; then
    yum update -y
else
    echo "不支持的包管理器"
    exit 1
fi

# 安装 Docker
if ! command -v docker &> /dev/null; then
    echo "正在安装 Docker..."
    if command -v apt-get &> /dev/null; then
        # Ubuntu/Debian
        apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        apt-get update
        apt-get install -y docker-ce docker-ce-cli containerd.io
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        yum install -y yum-utils
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        yum install -y docker-ce docker-ce-cli containerd.io
    fi
    
    # 启动 Docker 服务
    systemctl start docker
    systemctl enable docker
    
    echo "Docker 安装完成"
else
    echo "Docker 已安装"
fi

# 安装 Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "正在安装 Docker Compose..."
    if command -v apt-get &> /dev/null; then
        # 使用 apt 安装（推荐）
        apt-get install -y docker-compose-plugin
    else
        # 手动安装 Docker Compose
        DOCKER_COMPOSE_VERSION="v2.23.0"
        curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    fi
    
    echo "Docker Compose 安装完成"
else
    echo "Docker Compose 已安装"
fi

# 安装 Git（如果需要从 Git 仓库克隆项目）
if ! command -v git &> /dev/null; then
    echo "正在安装 Git..."
    if command -v apt-get &> /dev/null; then
        apt-get install -y git
    elif command -v yum &> /dev/null; then
        yum install -y git
    fi
    echo "Git 安装完成"
else
    echo "Git 已安装"
fi

# 配置防火墙（开放必要端口）
echo "正在配置防火墙..."
if command -v ufw &> /dev/null; then
    # Ubuntu UFW
    ufw allow 22/tcp   # SSH
    ufw allow 80/tcp   # HTTP
    ufw allow 8080/tcp # 后端API
    ufw --force enable
elif command -v firewall-cmd &> /dev/null; then
    # CentOS Firewalld
    firewall-cmd --permanent --add-port=22/tcp
    firewall-cmd --permanent --add-port=80/tcp
    firewall-cmd --permanent --add-port=8080/tcp
    firewall-cmd --reload
fi

echo "=========================================="
echo "服务器环境配置完成！"
echo "=========================================="
echo "已安装的软件："
echo "  - Docker: $(docker --version)"
echo "  - Docker Compose: $(docker-compose --version || docker compose version)"
echo "  - Git: $(git --version)"
echo "=========================================="
echo "下一步："
echo "1. 将项目文件上传到服务器"
echo "2. 上传微信支付证书文件到 certs/ 目录"
echo "3. 运行部署脚本 deploy.sh"
echo "=========================================="

