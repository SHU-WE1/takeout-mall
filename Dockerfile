# 使用Maven官方镜像作为构建阶段
FROM maven:3.8.6-openjdk-11-slim AS build

# 设置工作目录
WORKDIR /app

# 复制pom.xml文件
COPY pom.xml .
COPY sky-common/pom.xml ./sky-common/
COPY sky-pojo/pom.xml ./sky-pojo/
COPY sky-server/pom.xml ./sky-server/

# 下载依赖（利用Docker缓存层）
RUN mvn dependency:go-offline -B

# 复制源代码
COPY sky-common/src ./sky-common/src
COPY sky-pojo/src ./sky-pojo/src
COPY sky-server/src ./sky-server/src

# 构建应用
RUN mvn clean package -DskipTests

# 运行时阶段
FROM openjdk:11-jre-slim

# 设置工作目录
WORKDIR /app

# 从构建阶段复制jar文件
COPY --from=build /app/sky-server/target/sky-server-1.0-SNAPSHOT.jar app.jar

# 暴露端口
EXPOSE 8080

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 启动应用
ENTRYPOINT ["java", "-jar", "app.jar"]
