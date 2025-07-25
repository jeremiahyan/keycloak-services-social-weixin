# Keycloak WeChat Login Plugin

[🇺🇸 English](README_en-US.md) | **[🇨🇳 简体中文](README.md)**

> Keycloak微信登录插件，支持多种微信登录方式，完美适配Keycloak 26+版本

![Java CI with Maven](https://github.com/jeremiahyan/keycloak-services-social-weixin/workflows/Java%20CI%20with%20Maven/badge.svg)
[![Maven Package](https://github.com/jeremiahyan/keycloak-services-social-weixin/workflows/Maven%20Package/badge.svg)](https://github.com/jeremiahyan/keycloak-services-social-weixin/packages)

## ✨ 功能特性

- 🖥️ **PC端扫码登录** - 支持微信开放平台QR码登录
- 📱 **微信浏览器登录** - 自动检测微信环境，无缝登录
- 🔗 **小程序登录** - 支持微信小程序授权登录
- 📢 **公众号登录** - 关注公众号即可登录
- 🔄 **账号统一** - 基于unionid的多端账号关联
- 🚀 **最新版本** - 完美支持Keycloak 26.1.2+

## 🚀 快速开始

### 系统要求

- Java 21+
- Maven 3.6+
- Docker & Docker Compose
- Keycloak 26.0+

### 一键构建并启动

```bash
# 克隆项目
git clone https://github.com/jeremiahyan/keycloak-services-social-weixin.git
cd keycloak-services-social-weixin

# 查看所有可用命令
make help

# 一键构建并启动服务
make docker-up
```

### 访问管理界面

启动成功后，访问 [http://localhost:8080/admin/master/console/](http://localhost:8080/admin/master/console/)

- 用户名: `admin`
- 密码: `admin`

## 📖 构建命令

我们提供了完整的Makefile来简化构建流程：

```bash
# 构建JAR包（跳过测试）
make build

# 构建Docker镜像
make docker-build

# 启动服务
make docker-up

# 停止服务
make docker-down

# 查看日志
make docker-logs

# 清理资源
make clean
```

### 手动Maven命令

如果您喜欢使用Maven命令：

```bash
# Windows PowerShell
mvn clean compile package "-Dmaven.test.skip=true"

# Linux/Mac
mvn clean compile package -Dmaven.test.skip=true
```

## 🔧 部署说明

### 方式一：Docker Compose（推荐）

```bash
# 构建并启动
make docker-up

# 或者直接使用docker compose
docker compose up -d
```

### 方式二：手动部署

1. 构建JAR包：
   ```bash
   make build
   ```

2. 复制到Keycloak：
   ```bash
   cp target/keycloak-services-social-weixin-*.jar KEYCLOAK_HOME/providers/
   ```

3. 重新构建Keycloak（生产环境）：
   ```bash
   kc.sh build
   ```

4. 重启Keycloak服务

## ⚙️ 配置指南

### 1. 添加微信身份提供者

1. 登录Keycloak管理控制台
2. 选择您的Realm
3. 进入 **Identity Providers**
4. 点击 **Add provider** 选择 **WeChat (weixin)**

### 2. 配置参数说明

| 配置项 | 说明 | 必填 |
|--------|------|------|
| **Client ID** | 微信应用AppID | ✅ |
| **Client Secret** | 微信应用AppSecret | ✅ |
| **Open Client ID** | 开放平台AppID（PC扫码） | ⭕ |
| **Open Client Secret** | 开放平台AppSecret | ⭕ |
| **WMP Client ID** | 小程序AppID | ⭕ |
| **WMP Client Secret** | 小程序AppSecret | ⭕ |
| **Client ID 2** | 公众号AppID | ⭕ |
| **Client Secret 2** | 公众号AppSecret | ⭕ |

### 3. 登录流程说明

- **PC浏览器访问**: 显示微信QR码扫描登录
- **微信浏览器访问**: 自动跳转微信授权页面
- **小程序**: 使用jscode2session接口
- **公众号**: 支持关注后自动登录

## 🧪 开发和测试

### 本地开发环境

```bash
# 检查环境
make check-env

# 开发构建
make dev

# 查看版本信息
make version
```

### 运行测试

```bash
# 运行测试（需要先修复测试代码）
mvn test

# 跳过测试构建
make build
```

### 调试说明

本插件无法直接在IDE中运行调试，推荐调试方法：

1. 添加日志输出
2. 重新构建并部署
3. 查看Keycloak日志
4. 使用Docker进行本地测试

## 📦 版本支持

| Keycloak版本 | 插件版本 | 分支/标签 |
|-------------|---------|----------|
| 26.1.2+ | 1.0.1+ | `master` |
| 22.x | 0.5.x | `dev-keycloak-22` |
| 21.1 | - | `dev-keycloak-21` |
| 18.0.2 | - | `8069d7b` |
| 16.x | - | GitHub Packages |

## 🛠️ 项目结构

```
keycloak-services-social-weixin/
├── src/main/java/org/keycloak/social/weixin/
│   ├── WeiXinIdentityProvider.java        # 核心身份提供者
│   ├── WeiXinIdentityProviderFactory.java # 工厂类
│   ├── WeiXinIdentityBrokerService.java   # 认证服务
│   ├── Endpoint.java                      # OAuth回调端点
│   ├── helpers/                           # 工具类
│   ├── resources/                         # 资源提供者
│   └── cache/                            # 缓存相关
├── Dockerfile                            # Docker构建文件
├── compose.yml                           # Docker Compose配置
├── Makefile                             # 构建脚本
└── README.md                            # 项目文档
```

## 📄 支持的登录方式

### 1. PC端扫码登录
- 使用微信开放平台API
- 显示QR码供用户扫描
- 支持unionid账号关联

### 2. 微信浏览器登录
- 自动检测微信User-Agent
- 直接调用微信授权接口
- 无需扫码，体验流畅

### 3. 小程序登录
- 支持微信小程序jscode2session
- 独立的小程序AppID配置
- 与其他登录方式账号互通

### 4. 公众号登录
- 支持关注公众号即登录
- QR码场景值自动生成
- 适合营销场景使用

## 🤝 贡献指南

欢迎提交Issue和Pull Request！

1. Fork本项目
2. 创建功能分支: `git checkout -b feature/your-feature`
3. 提交更改: `git commit -am 'Add your feature'`
4. 推送分支: `git push origin feature/your-feature`
5. 提交Pull Request

## 📝 更新日志

### v1.0.1 (2025-01-26)
- ✅ 完全适配Keycloak 26.1.2
- ✅ 修复所有API兼容性问题
- ✅ 优化Docker构建流程
- ✅ 添加完整的Makefile支持
- ✅ 更新作者信息为Jeremiah Yan

### v0.5.x
- 支持Keycloak 22.x版本
- 新增公众号登录功能
- 优化多端账号关联

## 🙏 致谢

- 感谢 [jyqq163/keycloak-services-social-weixin](https://github.com/jyqq163/keycloak-services-social-weixin) 提供的基础代码
- 感谢原作者Jeff-Tian的基础工作
- 感谢所有贡献者的Pull Request和Issue反馈
- 感谢微信开发团队提供的完善API文档

## 📄 许可证

本项目采用 [MIT许可证](LICENSE)

## 🔗 相关链接

- [在线体验](https://keycloak.jiwai.win/realms/Brickverse/account/#/)
- [知乎文章：对接微信登录的三种方式](https://zhuanlan.zhihu.com/p/659232648)
- [其他Keycloak社交登录插件](https://afdian.net/album/1270bba089c511eebb825254001e7c00)

---

**⭐ 如果这个项目对您有帮助，请给我们一个Star！**