# 前端服务更新指南

## 快速更新步骤

### 方式一：使用 Git 拉取更新（推荐）

如果服务器上的项目已经是 Git 仓库：

#### 步骤 1: 本地提交并推送到 GitHub

```bash
# 在本地项目目录
cd "/Users/weishu/Desktop/takeout mall"

# 添加修改的文件
git add frontend-admin/src/views/dashboard/components/orderList.vue
git add frontend-admin/src/components/Empty/index.vue
git add frontend-admin/src/views/inform/index.vue
git add frontend-admin/src/layout/components/Navbar/index.vue

# 提交更改
git commit -m "更新前端：将 dashboard 中的中文文本翻译为日语"

# 推送到 GitHub
git push origin main
# 或者
git push origin master
```

#### 步骤 2: SSH 连接到服务器

```bash
ssh root@167.179.78.66
# 输入服务器密码
```

#### 步骤 3: 进入项目目录

```bash
cd /root/takeout-mall
```

#### 步骤 4: 拉取最新代码

```bash
git pull origin main
# 或者
git pull origin master
```

#### 步骤 5: 更新前端服务

**使用更新脚本（推荐）：**
```bash
chmod +x update-frontend.sh
./update-frontend.sh
```

**或者手动执行：**
```bash
# 停止前端服务
docker compose -f docker-compose.prod.yml --env-file .env.prod stop frontend

# 重新构建前端镜像
docker compose -f docker-compose.prod.yml --env-file .env.prod build --no-cache frontend

# 启动前端服务
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d frontend

# 查看服务状态
docker compose -f docker-compose.prod.yml --env-file .env.prod ps frontend

# 查看服务日志
docker compose -f docker-compose.prod.yml --env-file .env.prod logs -f frontend
```

#### 步骤 6: 验证更新

```bash
# 检查服务状态
docker compose -f docker-compose.prod.yml --env-file .env.prod ps frontend

# 查看服务日志
docker compose -f docker-compose.prod.yml --env-file .env.prod logs --tail=50 frontend

# 测试前端访问
curl http://localhost
```

---

### 方式二：直接上传文件更新（快速）

如果不想使用 Git，可以直接上传修改的文件：

#### 步骤 1: 在本地执行上传脚本

```bash
# 在本地项目目录
cd "/Users/weishu/Desktop/takeout mall"

# 给脚本添加执行权限
chmod +x upload-frontend.sh

# 执行上传脚本
./upload-frontend.sh
```

#### 步骤 2: SSH 连接到服务器

```bash
ssh root@167.179.78.66
# 输入服务器密码
```

#### 步骤 3: 更新前端服务

```bash
cd /root/takeout-mall

# 使用更新脚本
chmod +x update-frontend.sh
./update-frontend.sh
```

---

### 方式三：只上传修改的文件（最快）

如果只修改了几个文件，可以只上传这些文件：

#### 步骤 1: 在本地终端执行

```bash
# 上传修改的文件
scp "frontend-admin/src/views/dashboard/components/orderList.vue" root@167.179.78.66:/root/takeout-mall/frontend-admin/src/views/dashboard/components/
scp "frontend-admin/src/components/Empty/index.vue" root@167.179.78.66:/root/takeout-mall/frontend-admin/src/components/Empty/
scp "frontend-admin/src/views/inform/index.vue" root@167.179.78.66:/root/takeout-mall/frontend-admin/src/views/inform/
scp "frontend-admin/src/layout/components/Navbar/index.vue" root@167.179.78.66:/root/takeout-mall/frontend-admin/src/layout/components/Navbar/
```

#### 步骤 2: SSH 连接到服务器并更新

```bash
ssh root@167.179.78.66
cd /root/takeout-mall
chmod +x update-frontend.sh
./update-frontend.sh
```

---

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

### 2. 前端服务启动失败

检查日志：
```bash
docker compose -f docker-compose.prod.yml --env-file .env.prod logs frontend
```

常见原因：
- 前端构建错误（检查构建日志）
- Docker 镜像构建失败
- 端口被占用

### 3. 前端构建很慢

前端构建需要编译 Vue 项目，可能需要几分钟时间。这是正常现象，请耐心等待。

### 4. 更新后页面没有变化

可能原因：
- 浏览器缓存：清除浏览器缓存或使用无痕模式
- CDN 缓存：如果使用了 CDN，需要清除 CDN 缓存
- 服务没有重启：确认服务已重新构建并启动

解决方法：
```bash
# 强制重新构建（不使用缓存）
docker compose -f docker-compose.prod.yml --env-file .env.prod build --no-cache frontend

# 重启服务
docker compose -f docker-compose.prod.yml --env-file .env.prod restart frontend
```

### 5. 端口被占用

检查端口占用：
```bash
netstat -tulpn | grep :80
```

如果端口被占用，可以停止其他服务或修改端口配置。

---

## 一键更新命令

将以下命令保存为脚本，可以一键完成更新：

```bash
#!/bin/bash
cd /root/takeout-mall
git pull origin main
chmod +x update-frontend.sh
./update-frontend.sh
```

保存为 `quick-update-frontend.sh`，然后：
```bash
chmod +x quick-update-frontend.sh
./quick-update-frontend.sh
```

---

## 更新后端和前端

如果需要同时更新后端和前端：

```bash
# 在服务器上执行
cd /root/takeout-mall
git pull origin main

# 更新后端
chmod +x update-backend.sh
./update-backend.sh

# 更新前端
chmod +x update-frontend.sh
./update-frontend.sh
```

---

## 注意事项

1. **构建时间**：前端构建可能需要几分钟时间，请耐心等待
2. **浏览器缓存**：更新后可能需要清除浏览器缓存才能看到最新变化
3. **服务重启**：更新后服务会自动重启，但建议检查服务状态
4. **备份**：重要更新前建议备份当前部署

---

## 服务访问地址

更新完成后，可以通过以下地址访问：

- **前端管理页面**: http://167.179.78.66
- **后端API**: http://167.179.78.66:8080
- **API文档**: http://167.179.78.66:8080/doc.html







