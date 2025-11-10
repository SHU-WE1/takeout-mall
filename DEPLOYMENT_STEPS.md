# 服务器部署步骤（简化版）

## 第一步：上传项目文件到服务器

### 方式一：使用 scp 命令（推荐，简单直接）

```bash
# 1. 首先接受服务器的 SSH 密钥（首次连接时）
ssh root@167.179.78.66

# 2. 在本地终端执行上传命令
scp -r "/Users/weishu/Desktop/takeout mall" root@167.179.78.66:/root/takeout-mall

# 或者使用 rsync（更高效，排除不需要的文件）
rsync -avz --progress \
    --exclude 'node_modules' \
    --exclude 'target' \
    --exclude '.git' \
    --exclude '.idea' \
    --exclude '*.log' \
    --exclude 'dist' \
    --exclude 'build' \
    --exclude '.DS_Store' \
    "/Users/weishu/Desktop/takeout mall/" root@167.179.78.66:/root/takeout-mall/
```

**注意：** 首次连接时会提示输入密码（请使用实际的服务器密码）

### 方式二：手动使用 FTP/SFTP 客户端

可以使用 FileZilla、Cyberduck 等工具手动上传文件。

## 第二步：SSH 连接到服务器

```bash
ssh root@167.179.78.66
# 输入密码: your_server_password（请使用实际的服务器密码）
```

## 第三步：运行服务器初始化脚本

```bash
# 进入项目目录
cd /root/takeout-mall

# 给脚本添加执行权限
chmod +x server-setup.sh

# 运行初始化脚本
./server-setup.sh
```

这个脚本会自动：
- 更新系统包
- 安装 Docker
- 安装 Docker Compose
- 安装 Git
- 配置防火墙端口（22, 80, 8080）

## 第四步：运行部署脚本

```bash
# 确保在项目目录
cd /root/takeout-mall

# 给脚本添加执行权限
chmod +x deploy.sh

# 运行部署脚本
./deploy.sh
```

部署脚本会：
- 检查 Docker 环境
- 构建 Docker 镜像
- 启动所有服务（MySQL, Redis, 后端, 前端）
- 显示服务状态和日志

**注意：** 如果证书文件缺失，部署会继续，但微信支付功能暂时不可用。

## 第五步：验证部署

```bash
# 查看服务状态
docker-compose -f docker-compose.prod.yml --env-file .env.prod ps

# 查看服务日志
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f
```

访问地址：
- 前端: http://167.179.78.66
- 后端API: http://167.179.78.66:8080
- API文档: http://167.179.78.66:8080/doc.html

## 可选：上传微信支付证书文件

如果需要使用微信支付功能，可以稍后上传证书文件：

```bash
# 在本地执行
scp /path/to/apiclient_key.pem root@167.179.78.66:/root/takeout-mall/certs/
scp /path/to/wechatpay_*.pem root@167.179.78.66:/root/takeout-mall/certs/

# 在服务器上重启后端服务
ssh root@167.179.78.66
cd /root/takeout-mall
docker-compose -f docker-compose.prod.yml --env-file .env.prod restart backend
```

## 常见问题

### 1. SSH 连接失败

如果是首次连接，需要接受服务器的 SSH 密钥：
```bash
ssh -o StrictHostKeyChecking=accept-new root@167.179.78.66
```

### 2. 上传文件速度慢

可以尝试使用 rsync 的压缩选项，或者使用 SFTP 客户端工具。

### 3. 部署后服务无法访问

检查防火墙配置：
```bash
# Ubuntu/Debian
ufw status
ufw allow 80/tcp
ufw allow 8080/tcp

# CentOS/RHEL
firewall-cmd --list-all
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --reload
```

---

**快速命令总结：**

```bash
# 1. 上传文件
scp -r "/Users/weishu/Desktop/takeout mall" root@167.179.78.66:/root/takeout-mall

# 2. 连接服务器
ssh root@167.179.78.66

# 3. 初始化环境
cd /root/takeout-mall && chmod +x server-setup.sh && ./server-setup.sh

# 4. 部署项目
chmod +x deploy.sh && ./deploy.sh

# 5. 查看状态
docker-compose -f docker-compose.prod.yml --env-file .env.prod ps
```

