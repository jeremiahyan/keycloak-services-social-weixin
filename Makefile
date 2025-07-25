# Keycloak WeChat Plugin Makefile
# 微信登录插件构建脚本

# 变量定义 / Variables
PROJECT_NAME=keycloak-services-social-weixin
VERSION=1.0.1
DOCKER_IMAGE=dcr.lucidcube.io:6443/lucidcube/keycloak:latest
JAR_FILE=target/$(PROJECT_NAME)-$(VERSION).jar

# 默认目标 / Default target
.PHONY: help
help:
	@echo "可用命令 / Available commands:"
	@echo "  build          - 编译并打包JAR文件 / Build and package JAR"
	@echo "  clean          - 清理构建文件 / Clean build files"
	@echo "  docker-build   - 构建Docker镜像 / Build Docker image"
	@echo "  docker-up      - 启动Docker Compose服务 / Start Docker Compose services"
	@echo "  docker-down    - 停止Docker Compose服务 / Stop Docker Compose services"
	@echo "  docker-logs    - 查看Docker服务日志 / View Docker service logs"
	@echo "  test-skip      - 跳过测试构建 / Build skipping tests"
	@echo "  install        - 安装到本地Maven仓库 / Install to local Maven repository"
	@echo "  version        - 显示版本信息 / Show version info"

# 构建JAR包 / Build JAR package
.PHONY: build
build:
	@echo "🔨 构建JAR包... / Building JAR package..."
	mvn clean compile package "-Dmaven.test.skip=true"
	@echo "✅ 构建完成: $(JAR_FILE)"

# 跳过测试构建 / Build skipping tests
.PHONY: test-skip
test-skip: build

# 清理构建文件 / Clean build files
.PHONY: clean
clean:
	@echo "🧹 清理构建文件... / Cleaning build files..."
	mvn clean
	@echo "✅ 清理完成"

# 安装到本地Maven仓库 / Install to local Maven repository
.PHONY: install
install:
	@echo "📦 安装到本地仓库... / Installing to local repository..."
	mvn clean install "-Dmaven.test.skip=true"
	@echo "✅ 安装完成"

# 构建Docker镜像 / Build Docker image
.PHONY: docker-build
docker-build: build
	@echo "🐳 构建Docker镜像... / Building Docker image..."
	docker compose build --pull
	@echo "✅ Docker镜像构建完成: $(DOCKER_IMAGE)"

# 启动Docker Compose服务 / Start Docker Compose services
.PHONY: docker-up
docker-up: docker-build
	@echo "🚀 启动Keycloak服务... / Starting Keycloak service..."
	docker compose up -d
	@echo "✅ 服务已启动，访问: http://localhost:8080"
	@echo "👤 管理员账号: admin / admin"

# 停止Docker Compose服务 / Stop Docker Compose services
.PHONY: docker-down
docker-down:
	@echo "🛑 停止服务... / Stopping services..."
	docker compose down
	@echo "✅ 服务已停止"

# 查看Docker服务日志 / View Docker service logs
.PHONY: docker-logs
docker-logs:
	@echo "📄 查看服务日志... / Viewing service logs..."
	docker compose logs -f keycloak

# 重启Docker服务 / Restart Docker services
.PHONY: docker-restart
docker-restart: docker-down docker-up

# 显示版本信息 / Show version info
.PHONY: version
version:
	@echo "项目名称 / Project: $(PROJECT_NAME)"
	@echo "版本号 / Version: $(VERSION)"
	@echo "JAR文件 / JAR File: $(JAR_FILE)"
	@echo "Docker镜像 / Docker Image: $(DOCKER_IMAGE)"
	@echo ""
	@echo "Java版本 / Java Version:"
	@java -version
	@echo ""
	@echo "Maven版本 / Maven Version:"
	@mvn -version | head -1

# 快速开发构建 / Quick development build
.PHONY: dev
dev: clean build docker-build
	@echo "🎯 开发环境构建完成 / Development build completed"
	@echo "💡 运行 'make docker-up' 启动服务"

# 生产环境构建 / Production build
.PHONY: prod
prod: clean test-skip docker-build
	@echo "🏭 生产环境构建完成 / Production build completed"
	@echo "📋 构建信息:"
	@ls -la $(JAR_FILE)
	@docker images | grep keycloak

# 检查环境 / Check environment
.PHONY: check-env
check-env:
	@echo "🔍 检查构建环境... / Checking build environment..."
	@echo "Java版本检查:"
	@java -version
	@echo ""
	@echo "Maven版本检查:"
	@mvn -version
	@echo ""
	@echo "Docker版本检查:"
	@docker --version
	@echo ""
	@echo "Docker Compose版本检查:"
	@docker compose version
	@echo ""
	@echo "✅ 环境检查完成"

# 清理所有Docker资源 / Clean all Docker resources
.PHONY: docker-clean
docker-clean: docker-down
	@echo "🧹 清理Docker资源... / Cleaning Docker resources..."
	-docker rmi $(DOCKER_IMAGE) 2>/dev/null || true
	-docker system prune -f
	@echo "✅ Docker资源清理完成"

# 完整重建 / Full rebuild
.PHONY: rebuild
rebuild: clean docker-clean dev
	@echo "🔄 完整重建完成 / Full rebuild completed"