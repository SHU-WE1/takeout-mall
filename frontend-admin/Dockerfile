# 构建阶段
FROM node:14-alpine AS build

WORKDIR /app

# 安装构建工具
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    build-base \
    && ln -sf python3 /usr/bin/python

# 复制依赖文件
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制源代码
COPY . .

# 设置生产环境变量
ENV NODE_ENV=production

# 构建生产版本（增加内存限制）
RUN NODE_OPTIONS="--max_old_space_size=4096" npm run build

# 生产阶段
FROM nginx:alpine

# 复制 Nginx 配置
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 复制构建产物
COPY --from=build /app/dist /usr/share/nginx/html

# 设置权限
RUN chmod -R 755 /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
