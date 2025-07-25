# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Response Language / 回复语言

When responding about this project, always use bilingual format (Chinese and English) to ensure clarity for all users.
在回复关于本项目的问题时，请始终使用中英双语格式，以确保所有用户都能理解。

## Project Overview

This is a Keycloak identity provider plugin for WeChat (微信) login integration. It supports multiple WeChat login methods:
- PC QR code login via WeChat Open Platform
- WeChat browser login (mobile)
- WeChat Mini Program login
- WeChat Official Account follow-to-login

**Important**: This project requires JDK 17 or higher (currently using Java 21).

## Build Commands

```bash
# Install dependencies and compile
mvn install

# Package the plugin
mvn package

# Run tests
mvn clean test

# Run a single test class
mvn test -Dtest=WeiXinIdentityProviderTest

# Run a single test method
mvn test -Dtest=WeiXinIdentityProviderTest#performLoginThrowsIfHttpRequestIsNull

# Update version (example to 0.5.14)
mvn versions:set -DnewVersion=0.5.14
```

## Key Dependencies

- **Keycloak 26.1.2**: Core platform
- **Java 21**: Language version
- **JUnit 5**: Testing framework
- **Mockito & PowerMock**: Mocking for tests
- **Gson**: JSON processing
- **Lombok**: Code generation

## Architecture

### Core Components

1. **WeiXinIdentityProvider** (`src/main/java/org/keycloak/social/weixin/WeiXinIdentityProvider.java`)
   - Main provider implementation extending `AbstractOAuth2IdentityProvider`
   - Handles different login flows based on user agent detection
   - Manages OAuth2 flow for WeChat authentication
   - Key methods:
     - `createAuthorizationUrl()`: Detects user agent and creates appropriate auth URL
     - `getFederatedIdentity()`: Handles different response types based on `WechatLoginType`

2. **WeiXinIdentityProviderFactory** (`src/main/java/org/keycloak/social/weixin/WeiXinIdentityProviderFactory.java`)
   - Factory class for creating provider instances
   - Defines configuration properties for Keycloak admin UI
   - Provider ID: `weixin`

3. **WeiXinIdentityBrokerService** (`src/main/java/org/keycloak/social/weixin/WeiXinIdentityBrokerService.java`)
   - Handles authentication callbacks and user linking
   - Manages the broker authentication flow
   - Processes state parameters and manages session codes

4. **Custom Resource Providers**
   - `QrCodeResourceProvider`: Handles QR code generation for WeChat Official Account
   - `WechatCallbackResourceProvider`: Processes WeChat callbacks

5. **Endpoint** (`src/main/java/org/keycloak/social/weixin/Endpoint.java`)
   - Handles OAuth callback endpoints
   - Processes different types of WeChat authentication responses

6. **WechatLoginType** (`src/main/java/org/keycloak/social/weixin/WechatLoginType.java`)
   - Enum defining login types: `FROM_PC_QR_CODE_SCANNING`, `FROM_WECHAT_BROWSER`, `FROM_WECHAT_MINI_PROGRAM`

### Login Flow Types

1. **PC Browser** (`FROM_PC_QR_CODE_SCANNING`)
   - Uses WeChat Open Platform (`OPEN_AUTH_URL`) or custom QR code flow
   - Authorization URL: `https://open.weixin.qq.com/connect/qrconnect`
   - Scope: `snsapi_login`

2. **WeChat Browser** (`FROM_WECHAT_BROWSER`)
   - Detected via User-Agent containing "micromessenger"
   - Authorization URL: `https://open.weixin.qq.com/connect/oauth2/authorize`
   - Scope: `snsapi_userinfo`
   - Redirects with `#wechat_redirect` fragment

3. **Mini Program** (`FROM_WECHAT_MINI_PROGRAM`)
   - Uses `WMP_AUTH_URL`: `https://api.weixin.qq.com/sns/jscode2session`
   - Requires separate app credentials (`wmpClientId`/`wmpClientSecret`)

### Configuration

The plugin supports multiple WeChat app configurations:
- `clientId`/`clientSecret`: Standard WeChat app credentials
- `openClientId`/`openClientSecret`: WeChat Open Platform credentials
- `wmpClientId`/`wmpClientSecret`: WeChat Mini Program credentials
- `clientId2`/`clientSecret2`: WeChat Official Account credentials

## Plugin Deployment

After building, copy the JAR to Keycloak:
```bash
cp target/keycloak-services-social-weixin-*.jar KEYCLOAK_HOME/providers/
# For production Keycloak, run:
kc.sh build
```

### Supported Keycloak Versions
- Keycloak 16: Use package from https://github.com/Jeff-Tian/keycloak-services-social-weixin/packages/225091
- Keycloak 18.0.2: Branch `8069d7b32cb225742d7566d61e7ca0d0e0e389a5`
- Keycloak 21.1: Branch `dev-keycloak-21`
- Keycloak 22: Branch `dev-keycloak-22`
- Keycloak 26.1.2: Current master branch

## Testing

Tests use JUnit 5 with Mockito for mocking Keycloak components. Key test classes:
- `WeiXinIdentityProviderTest`: Core provider logic
- `JsonHelperTest`, `WMPHelperTest`: Utility class tests
- Mock classes in `org.keycloak.social.weixin.mock` package

## Development Notes

### Debugging
- This is not a standalone program and cannot be run directly from IDE
- Debug by adding logging statements and restarting Keycloak
- Use Docker or deploy to server and check logs
- Common logging pattern: `logger.info("message = " + variable)`

### Key Implementation Details
- User agent detection in `WeiXinIdentityProvider.createAuthorizationUrl()` determines login flow
- WeChat union ID is preferred over open ID for user identification
- Account linking requires binding to same WeChat Open Platform
- State parameter encodes session information using `IdentityBrokerState`
- OAuth2 parameters use WeChat-specific names: `appid` instead of `client_id`, `secret` instead of `client_secret`

### GitHub Actions
- Automatic packaging on master branch commits
- Automatic release when version number changes in pom.xml
- Remember to update version number to avoid conflicts with existing packages

## Service Configuration

Register the provider via SPI files in `src/main/resources/META-INF/services/`:
- `org.keycloak.broker.social.SocialIdentityProviderFactory`
- `org.keycloak.services.resource.RealmResourceProviderFactory`
- `org.keycloak.storage.UserStorageProviderFactory`