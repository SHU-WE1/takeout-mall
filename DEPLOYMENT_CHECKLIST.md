# 服务器部署检查清单

## 部署前准备

### ✅ 1. 本地文件准备
- [x] `docker-compose.prod.yml` - 生产环境 Docker Compose 配置
- [x] `.env.prod` - 生产环境变量文件（包含服务器IP）
- [x] `server-setup.sh` - 服务器初始化脚本
- [x] `deploy.sh` - 部署脚本
- [x] `upload-to-server.sh` - 文件上传脚本
- [x] `DEPLOYMENT_GUIDE.md` - 详细部署文档

### ✅ 2. 微信支付证书文件
- [ ] `apiclient_key.pem` - 微信支付私钥文件
- [ ] `wechatpay_*.pem` - 微信支付平台证书文件

### ✅ 3. 服务器信息
- [x] IP地址: 167.179.78.66
- [x] 用户名: root
- [x] 密码: `your_server_password`（请使用实际的服务器密码）

## 部署步骤

### 步骤 1: 上传项目文件到服务器

**方式一：使用 upload-to-server.sh 脚本（推荐）**
```bash
cd /Users/weishu/Desktop/takeout\ mall
./upload-to-server.sh
```

**方式二：使用 scp 手动上传**
```bash
scp -r /Users/weishu/Desktop/takeout\ mall root@167.179.78.66:/root/takeout-mall
```

### 步骤 2: 上传微信支付证书文件

```bash
# 在服务器上创建 certs 目录
ssh root@167.179.78.66 "mkdir -p /root/takeout-mall/certs"

# 上传证书文件（需要从本地找到证书文件的位置）
scp /path/to/apiclient_key.pem root@167.179.78.66:/root/takeout-mall/certs/
scp /path/to/wechatpay_*.pem root@167.179.78.66:/root/takeout-mall/certs/
```

### 步骤 3: 服务器环境初始化

```bash
# SSH 连接到服务器
ssh root@167.179.78.66

# 进入项目目录
cd /root/takeout-mall

# 运行初始化脚本
chmod +x server-setup.sh
./server-setup.sh
```

**初始化脚本会：**
- 更新系统包
- 安装 Docker
- 安装 Docker Compose
- 安装 Git
- 配置防火墙（开放 22, 80, 8080 端口）

### 步骤 4: 部署项目

```bash
# 在服务器上运行部署脚本
cd /root/takeout-mall
chmod +x deploy.sh
./deploy.sh
```

**部署脚本会：**
- 检查 Docker 和 Docker Compose
- 检查必要文件
- 停止现有容器
- 构建 Docker 镜像
- 启动所有服务
- 显示服务状态和日志

## 部署后验证

### ✅ 1. 检查服务状态

```bash
docker-compose -f docker-compose.prod.yml --env-file .env.prod ps
```

应该看到所有服务都在运行：
- sky-mysql (MySQL)
- sky-redis (Redis)
- sky-backend (后端服务)
- sky-frontend (前端服务)

### ✅ 2. 检查服务日志

```bash
# 查看所有服务日志
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f

# 查看后端服务日志
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f backend
```

### ✅ 3. 测试访问

- [ ] 前端: http://167.179.78.66
- [ ] 后端API: http://167.179.78.66:8080
- [ ] API文档: http://167.179.78.66:8080/doc.html

### ✅ 4. 测试API接口

```bash
# 测试后端健康检查
curl http://167.179.78.66:8080/admin/employee/login

# 测试前端访问
curl http://167.179.78.66
```

## 常见问题排查

### 问题 1: 端口被占用
```bash
# 检查端口占用
netstat -tulpn | grep :80
netstat -tulpn | grep :8080
```

### 问题 2: 容器无法启动
```bash
# 查看容器日志
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs [服务名]

# 检查容器状态
docker ps -a
```

### 问题 3: 数据库连接失败
```bash
# 检查 MySQL 容器
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs mysql

# 检查后端服务日志
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs backend
```

### 问题 4: 微信支付证书问题
```bash
# 检查证书文件
ls -la /root/takeout-mall/certs/

# 检查证书文件权限
chmod 644 /root/takeout-mall/certs/*.pem
```

## 部署完成后的操作

1. **修改服务器密码**（安全建议）
2. **配置 SSH 密钥登录**（安全建议）
3. **设置定期备份**（数据安全）
4. **配置日志轮转**（避免日志文件过大）
5. **设置监控告警**（及时发现问题）

## 快速命令参考

```bash
# 查看服务状态
docker-compose -f docker-compose.prod.yml --env-file .env.prod ps

# 查看服务日志
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f

# 重启服务
docker-compose -f docker-compose.prod.yml --env-file .env.prod restart

# 停止服务
docker-compose -f docker-compose.prod.yml --env-file .env.prod down

# 重新部署
docker-compose -f docker-compose.prod.yml --env-file .env.prod down
docker-compose -f docker-compose.prod.yml --env-file .env.prod build --no-cache
docker-compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

---

**部署完成后访问地址：**
- 前端: http://167.179.78.66
- 后端API: http://167.179.78.66:8080
- API文档: http://167.179.78.66:8080/doc.html

