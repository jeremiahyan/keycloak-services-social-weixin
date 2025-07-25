# Keycloak WeChat Login Plugin

**[🇺🇸 English](README_en-US.md)** | [🇨🇳 简体中文](README.md)

> WeChat Login integration for Keycloak, supporting multiple WeChat login methods with full compatibility for Keycloak 26+

![Java CI with Maven](https://github.com/jeremiahyan/keycloak-services-social-weixin/workflows/Java%20CI%20with%20Maven/badge.svg)
[![Maven Package](https://github.com/jeremiahyan/keycloak-services-social-weixin/workflows/Maven%20Package/badge.svg)](https://github.com/jeremiahyan/keycloak-services-social-weixin/packages)

## ✨ Features

- 🖥️ **PC QR Code Login** - WeChat Open Platform QR code scanning
- 📱 **WeChat Browser Login** - Seamless login within WeChat app
- 🔗 **Mini Program Login** - WeChat Mini Program authorization
- 📢 **Official Account Login** - Login by following WeChat Official Account
- 🔄 **Unified Accounts** - Account linking based on unionid
- 🚀 **Latest Version** - Full support for Keycloak 26.1.2+

## 🚀 Quick Start

### System Requirements

- Java 21+
- Maven 3.6+
- Docker & Docker Compose
- Keycloak 26.0+

### One-click Build and Start

```bash
# Clone the project
git clone https://github.com/jeremiahyan/keycloak-services-social-weixin.git
cd keycloak-services-social-weixin

# View all available commands
make help

# One-click build and start
make docker-up
```

### Access Admin Console

After successful startup, visit [http://localhost:8080/admin/master/console/](http://localhost:8080/admin/master/console/)

- Username: `admin`
- Password: `admin`

## 📖 Build Commands

We provide a complete Makefile to simplify the build process:

```bash
# Build JAR package (skip tests)
make build

# Build Docker image
make docker-build

# Start services
make docker-up

# Stop services
make docker-down

# View logs
make docker-logs

# Clean resources
make clean
```

### Manual Maven Commands

If you prefer using Maven directly:

```bash
# Windows PowerShell
mvn clean compile package "-Dmaven.test.skip=true"

# Linux/Mac
mvn clean compile package -Dmaven.test.skip=true
```

## 🔧 Deployment

### Option 1: Docker Compose (Recommended)

```bash
# Build and start
make docker-up

# Or use docker compose directly
docker compose up -d
```

### Option 2: Manual Deployment

1. Build JAR package:
   ```bash
   make build
   ```

2. Copy to Keycloak:
   ```bash
   cp target/keycloak-services-social-weixin-*.jar KEYCLOAK_HOME/providers/
   ```

3. Rebuild Keycloak (production):
   ```bash
   kc.sh build
   ```

4. Restart Keycloak service

## ⚙️ Configuration Guide

### 1. Add WeChat Identity Provider

1. Login to Keycloak Admin Console
2. Select your Realm
3. Go to **Identity Providers**
4. Click **Add provider** and select **WeChat (weixin)**

### 2. Configuration Parameters

| Parameter | Description | Required |
|-----------|-------------|----------|
| **Client ID** | WeChat App ID | ✅ |
| **Client Secret** | WeChat App Secret | ✅ |
| **Open Client ID** | Open Platform App ID (PC QR) | ⭕ |
| **Open Client Secret** | Open Platform App Secret | ⭕ |
| **WMP Client ID** | Mini Program App ID | ⭕ |
| **WMP Client Secret** | Mini Program App Secret | ⭕ |
| **Client ID 2** | Official Account App ID | ⭕ |
| **Client Secret 2** | Official Account App Secret | ⭕ |

### 3. Login Flow Explanation

- **PC Browser**: Display WeChat QR code for scanning
- **WeChat Browser**: Auto redirect to WeChat authorization page  
- **Mini Program**: Use jscode2session API
- **Official Account**: Support auto-login after following

## 🧪 Development and Testing

### Local Development Environment

```bash
# Check environment
make check-env

# Development build
make dev

# View version info
make version
```

### Running Tests

```bash
# Run tests (need to fix test code first)
mvn test

# Build skipping tests
make build
```

### Debugging Instructions

This plugin cannot be run directly in IDE. Recommended debugging approach:

1. Add logging statements
2. Rebuild and deploy
3. Check Keycloak logs
4. Use Docker for local testing

## 📦 Version Support

| Keycloak Version | Plugin Version | Branch/Tag |
|------------------|----------------|------------|
| 26.1.2+ | 1.0.1+ | `master` |
| 22.x | 0.5.x | `dev-keycloak-22` |
| 21.1 | - | `dev-keycloak-21` |
| 18.0.2 | - | `8069d7b` |
| 16.x | - | GitHub Packages |

## 🛠️ Project Structure

```
keycloak-services-social-weixin/
├── src/main/java/org/keycloak/social/weixin/
│   ├── WeiXinIdentityProvider.java        # Core identity provider
│   ├── WeiXinIdentityProviderFactory.java # Factory class
│   ├── WeiXinIdentityBrokerService.java   # Authentication service
│   ├── Endpoint.java                      # OAuth callback endpoint
│   ├── helpers/                           # Utility classes
│   ├── resources/                         # Resource providers
│   └── cache/                            # Cache related
├── Dockerfile                            # Docker build file
├── compose.yml                           # Docker Compose config
├── Makefile                             # Build scripts
└── README.md                            # Project documentation
```

## 📄 Supported Login Methods

### 1. PC QR Code Login
- Uses WeChat Open Platform API
- Display QR code for user scanning
- Support unionid account linking

### 2. WeChat Browser Login
- Auto-detect WeChat User-Agent
- Direct call to WeChat authorization API
- No QR code needed, smooth experience

### 3. Mini Program Login
- Support WeChat Mini Program jscode2session
- Independent Mini Program AppID configuration
- Account interoperability with other login methods

### 4. Official Account Login
- Support login by following Official Account
- Auto-generate QR code scene values
- Suitable for marketing scenarios

## 🤝 Contributing

Welcome to submit Issues and Pull Requests!

1. Fork this project
2. Create feature branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -am 'Add your feature'`
4. Push branch: `git push origin feature/your-feature`
5. Submit Pull Request

## 📝 Changelog

### v1.0.1 (2025-01-26)
- ✅ Full compatibility with Keycloak 26.1.2
- ✅ Fixed all API compatibility issues
- ✅ Optimized Docker build process
- ✅ Added complete Makefile support
- ✅ Updated author information to Jeremiah Yan

### v0.5.x
- Support for Keycloak 22.x
- Added Official Account login
- Optimized multi-platform account linking

## 🙏 Acknowledgments

- Thanks to [jyqq163/keycloak-services-social-weixin](https://github.com/jyqq163/keycloak-services-social-weixin) for the base code
- Thanks to original author Jeff-Tian for the foundational work
- Thanks to all contributors for Pull Requests and Issue feedback
- Thanks to WeChat development team for comprehensive API documentation

## 📄 License

This project is licensed under the [MIT License](LICENSE)

## 🔗 Related Links

- [Live Demo](https://keycloak.jiwai.win/realms/Brickverse/account/#/)
- [Article: Three Ways to Integrate WeChat Login (Chinese)](https://zhuanlan.zhihu.com/p/659232648)
- [Other Keycloak Social Login Plugins](https://afdian.net/album/1270bba089c511eebb825254001e7c00)

---

**⭐ If this project helps you, please give us a Star!**