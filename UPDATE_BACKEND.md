# 后端服务更新指南

## 快速更新步骤

### 步骤 1: SSH 连接到服务器

```bash
ssh root@167.179.78.66
# 输入服务器密码
```

### 步骤 2: 进入项目目录

```bash
cd /root/takeout-mall
```

### 步骤 3: 拉取最新代码

**如果项目是 Git 仓库：**
```bash
git pull origin main
# 或者
git pull origin master
```

**如果项目不是 Git 仓库：**
需要先从本地上传代码（见下方说明）

### 步骤 4: 更新后端服务

**方式一：使用更新脚本（推荐）**
```bash
chmod +x update-backend.sh
./update-backend.sh
```

**方式二：手动执行**
```bash
# 停止后端服务
docker compose -f docker-compose.prod.yml --env-file .env.prod stop backend

# 重新构建后端镜像
docker compose -f docker-compose.prod.yml --env-file .env.prod build --no-cache backend

# 启动后端服务
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d backend

# 查看服务状态
docker compose -f docker-compose.prod.yml --env-file .env.prod ps backend

# 查看服务日志
docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f backend
```

### 步骤 5: 验证更新

```bash
# 检查服务状态
docker compose -f docker-compose.prod.yml --env-file .env.prod ps backend

# 查看服务日志
docker compose -f docker-compose.prod.yml --env-file .env.prod logs --tail=50 backend

# 测试 API 访问
curl http://localhost:8080/doc.html
```

## 如果服务器上没有 Git 仓库

如果服务器上的项目不是 Git 仓库，需要先从本地上传代码：

### 从本地上传代码

```bash
# 在本地终端执行
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

然后在服务器上执行步骤 4。

## 初始化 Git 仓库（可选）

如果希望服务器上的项目也使用 Git 管理：

```bash
# 在服务器上执行
cd /root/takeout-mall

# 初始化 Git 仓库（如果还没有）
git init

# 添加远程仓库
git remote add origin <your-github-repo-url>

# 拉取代码
git pull origin main
```

## 常见问题

### 1. Git pull 失败

如果 Git pull 失败，可能是因为：
- 服务器上的代码有本地修改
- 远程仓库 URL 配置不正确

解决方法：
```bash
# 查看 Git 状态
git status

# 如果有本地修改，可以先暂存
git stash

# 然后再拉取
git pull origin main

# 恢复本地修改（如果需要）
git stash pop
```

### 2. 后端服务启动失败

检查日志：
```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod logs backend
```

常见原因：
- 代码编译错误
- 环境变量配置错误
- 数据库连接失败

### 3. 端口被占用

检查端口占用：
```bash
netstat -tulpn | grep :8080
```

如果端口被占用，可以停止其他服务或修改端口配置。

## 一键更新命令

将以下命令保存为脚本，可以一键完成更新：

```bash
#!/bin/bash
cd /root/takeout-mall
git pull origin main
chmod +x update-backend.sh
./update-backend.sh
```

保存为 `quick-update.sh`，然后：
```bash
chmod +x quick-update.sh
./quick-update.sh
```








