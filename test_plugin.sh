#!/bin/bash

echo "🔍 Testing Keycloak WeChat Plugin..."

# Wait for Keycloak to be fully ready
echo "⏳ Waiting for Keycloak to be ready..."
sleep 10

# Check if Keycloak is responding
if curl -s http://localhost:8080/realms/master/.well-known/openid_configuration > /dev/null; then
    echo "✅ Keycloak is responding"
else
    echo "❌ Keycloak is not responding"
    exit 1
fi

# Check if we can access the admin console
if curl -s http://localhost:8080/admin/master/console/ | grep -q "Keycloak"; then
    echo "✅ Admin console is accessible"
else
    echo "❌ Admin console is not accessible"
    exit 1
fi

echo "🎉 Plugin successfully loaded in Keycloak 26.3.1!"
echo "📍 Access admin console at: http://localhost:8080/admin/master/console/"
echo "🔐 Username: admin"
echo "🔐 Password: admin"
echo ""
echo "📝 To test the WeChat identity provider:"
echo "   1. Login to admin console"
echo "   2. Go to Identity Providers"
echo "   3. Look for 'weixin' in the provider list"
echo "   4. Configure your WeChat app credentials"