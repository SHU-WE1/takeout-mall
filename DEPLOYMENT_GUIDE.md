# 服务器部署指南

## 服务器信息

- **IP地址**: 167.179.78.66
- **IPv6**: 2001:19f0:7001:28a8:5400:05ff:fec1:8e1c
- **用户名**: root
- **密码**: `your_server_password`（请使用实际的服务器密码）

## 部署步骤

### 第一步：服务器环境初始化

1. **连接到服务器**
   ```bash
   ssh root@167.179.78.66
   ```

2. **上传项目文件到服务器**
   
   在本地执行（需要先安装 `rsync` 或使用 `scp`）：
   ```bash
   # 使用 rsync（推荐，可以排除不需要的文件）
   rsync -avz --exclude 'node_modules' --exclude 'target' --exclude '.git' \
     /Users/weishu/Desktop/takeout\ mall/ root@167.179.78.66:/root/takeout-mall/
   
   # 或使用 scp
   scp -r /Users/weishu/Desktop/takeout\ mall root@167.179.78.66:/root/takeout-mall
   ```

3. **上传微信支付证书文件**
   ```bash
   # 在服务器上创建 certs 目录
   ssh root@167.179.78.66 "mkdir -p /root/takeout-mall/certs"
   
   # 上传证书文件
   scp apiclient_key.pem root@167.179.78.66:/root/takeout-mall/certs/
   scp wechatpay_*.pem root@167.179.78.66:/root/takeout-mall/certs/
   ```

4. **在服务器上运行初始化脚本**
   ```bash
   ssh root@167.179.78.66
   cd /root/takeout-mall
   chmod +x server-setup.sh
   ./server-setup.sh
   ```

   这个脚本会：
   - 更新系统包
   - 安装 Docker
   - 安装 Docker Compose
   - 安装 Git
   - 配置防火墙（开放 22, 80, 8080 端口）

### 第二步：部署项目

1. **进入项目目录**
   ```bash
   ssh root@167.179.78.66
   cd /root/takeout-mall
   ```

2. **检查必要文件**
   ```bash
   # 确认以下文件存在
   ls -la docker-compose.prod.yml
   ls -la .env.prod
   ls -la certs/apiclient_key.pem
   ls -la certs/wechatpay_*.pem
   ```

3. **运行部署脚本**
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

   部署脚本会：
   - 检查 Docker 和 Docker Compose
   - 检查必要文件
   - 停止现有容器
   - 构建 Docker 镜像
   - 启动所有服务
   - 显示服务状态和日志

### 第三步：验证部署

1. **检查服务状态**
   ```bash
   docker-compose -f docker-compose.prod.yml --env-file .env.prod ps
   ```

   应该看到所有服务都在运行：
   - sky-mysql (MySQL)
   - sky-redis (Redis)
   - sky-backend (后端服务)
   - sky-frontend (前端服务)

2. **查看服务日志**
   ```bash
   # 查看所有服务日志
   docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f
   
   # 查看特定服务日志
   docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f backend
   docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f frontend
   ```

3. **测试访问**
   - 前端: http://167.179.78.66
   - 后端API: http://167.179.78.66:8080
   - API文档: http://167.179.78.66:8080/doc.html

## 常用管理命令

### 查看服务状态
```bash
docker-compose -f docker-compose.prod.yml --env-file .env.prod ps
```

### 查看服务日志
```bash
# 查看所有服务日志
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f

# 查看特定服务日志
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f backend
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f frontend
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f mysql
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs -f redis
```

### 重启服务
```bash
# 重启所有服务
docker-compose -f docker-compose.prod.yml --env-file .env.prod restart

# 重启特定服务
docker-compose -f docker-compose.prod.yml --env-file .env.prod restart backend
docker-compose -f docker-compose.prod.yml --env-file .env.prod restart frontend
```

### 停止服务
```bash
docker-compose -f docker-compose.prod.yml --env-file .env.prod down
```

### 停止并删除数据卷（谨慎使用）
```bash
docker-compose -f docker-compose.prod.yml --env-file .env.prod down -v
```

### 重新构建并启动
```bash
# 停止服务
docker-compose -f docker-compose.prod.yml --env-file .env.prod down

# 重新构建镜像
docker-compose -f docker-compose.prod.yml --env-file .env.prod build --no-cache

# 启动服务
docker-compose -f docker-compose.prod.yml --env-file .env.prod up -d
```

## 故障排查

### 1. 端口被占用
```bash
# 检查端口占用
netstat -tulpn | grep :80
netstat -tulpn | grep :8080

# 如果端口被占用，可以修改 docker-compose.prod.yml 中的端口映射
```

### 2. 容器无法启动
```bash
# 查看容器日志
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs [服务名]

# 检查容器状态
docker ps -a
```

### 3. 数据库连接失败
```bash
# 检查 MySQL 容器是否正常运行
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs mysql

# 检查后端服务日志
docker-compose -f docker-compose.prod.yml --env-file .env.prod logs backend
```

### 4. 前端无法访问后端API
```bash
# 检查 Nginx 配置
docker exec -it sky-frontend cat /etc/nginx/conf.d/default.conf

# 检查后端服务是否正常运行
curl http://localhost:8080/admin/employee/login
```

### 5. 微信支付证书问题
```bash
# 检查证书文件是否存在
ls -la certs/

# 检查证书文件权限
chmod 644 certs/*.pem
```

## 更新部署

### 方式一：使用 Git 拉取更新（推荐）

如果服务器上的项目已经是 Git 仓库：

1. **SSH 连接到服务器**
   ```bash
   ssh root@167.179.78.66
   ```

2. **进入项目目录并拉取最新代码**
   ```bash
   cd /root/takeout-mall
   git pull origin main
   # 或者
   git pull origin master
   ```

3. **更新后端服务**
   ```bash
   # 使用更新脚本（推荐）
   chmod +x update-backend.sh
   ./update-backend.sh
   
   # 或者手动执行
   docker compose -f docker-compose.prod.yml --env-file .env.prod stop backend
   docker compose -f docker-compose.prod.yml --env-file .env.prod build --no-cache backend
   docker compose -f docker-compose.prod.yml --env-file .env.prod up -d backend
   ```

### 方式二：使用 rsync 上传更新

如果服务器上的项目不是 Git 仓库：

1. **在本地更新代码并推送到 Git**
   ```bash
   git add .
   git commit -m "更新代码"
   git push
   ```

2. **重新上传到服务器**
   ```bash
   rsync -avz --exclude 'node_modules' --exclude 'target' --exclude '.git' \
     /Users/weishu/Desktop/takeout\ mall/ root@167.179.78.66:/root/takeout-mall/
   ```

3. **在服务器上更新后端服务**
   ```bash
   ssh root@167.179.78.66
   cd /root/takeout-mall
   chmod +x update-backend.sh
   ./update-backend.sh
   ```

### 方式三：完整重新部署

如果需要重新部署所有服务（包括前端、MySQL、Redis）：

```bash
ssh root@167.179.78.66
cd /root/takeout-mall
./deploy.sh
```

## 安全建议

1. **修改默认密码**: 部署后立即修改服务器 root 密码
2. **配置 SSH 密钥**: 使用 SSH 密钥登录，禁用密码登录
3. **配置防火墙**: 只开放必要端口（22, 80, 8080）
4. **定期备份**: 定期备份数据库和重要文件
5. **更新系统**: 定期更新系统和 Docker 镜像
6. **监控日志**: 定期查看服务日志，及时发现问题和异常

## 备份和恢复

### 备份数据库
```bash
# 备份 MySQL 数据（请替换 your_mysql_password 为实际的 MySQL 密码）
docker exec sky-mysql mysqldump -u root -pyour_mysql_password sky_take_out > backup_$(date +%Y%m%d).sql

# 备份 Redis 数据（请替换 your_redis_password 为实际的 Redis 密码）
docker exec sky-redis redis-cli --pass your_redis_password SAVE
docker cp sky-redis:/data/dump.rdb ./redis_backup_$(date +%Y%m%d).rdb
```

### 恢复数据库
```bash
# 恢复 MySQL 数据（请替换 your_mysql_password 为实际的 MySQL 密码）
docker exec -i sky-mysql mysql -u root -pyour_mysql_password sky_take_out < backup_20231110.sql

# 恢复 Redis 数据
docker cp redis_backup_20231110.rdb sky-redis:/data/dump.rdb
docker restart sky-redis
```

## 注意事项

1. **证书文件**: 确保微信支付证书文件已正确上传到 `certs/` 目录
2. **环境变量**: 生产环境的 `.env.prod` 文件包含敏感信息，不要提交到 Git
3. **端口配置**: 生产环境使用标准端口（80, 8080），本地开发使用非标准端口（8081, 3307, 6380）
4. **数据库初始化**: 首次部署会自动执行 `docs/sql/` 目录下的 SQL 脚本初始化数据库
5. **日志管理**: 生产环境建议配置日志轮转，避免日志文件过大

## 联系支持

如果遇到问题，请检查：
1. 服务日志
2. 容器状态
3. 网络连接
4. 防火墙配置
5. 证书文件

---

**部署完成后，访问地址：**
- 前端: http://167.179.78.66
- 后端API: http://167.179.78.66:8080
- API文档: http://167.179.78.66:8080/doc.html

