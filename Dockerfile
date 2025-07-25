FROM quay.io/keycloak/keycloak:latest

ARG KEYCLOAK_WEIXIN_VERSION
ENV KEYCLOAK_WEIXIN_VERSION=${KEYCLOAK_WEIXIN_VERSION:-1.0.0}

COPY target/keycloak-services-social-weixin-${KEYCLOAK_WEIXIN_VERSION}.jar /opt/keycloak/providers/

CMD ["start-dev", "--hostname-strict=false"]