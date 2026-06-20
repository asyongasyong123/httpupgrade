FROM alpine:latest

ENV PORT=8080

# Install base tools first
RUN apk update && apk add --no-cache \
    ca-certificates \
    curl \
    nginx \
    bash \
    tar

# Download and install official Xray core directly
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then XRAY_ARCH="amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then XRAY_ARCH="arm64"; \
    else XRAY_ARCH="amd64"; fi && \
    curl -fsSL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-${XRAY_ARCH}.tar.gz -o xray.tar.gz && \
    tar -xzf xray.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && \
    rm -f xray.tar.gz

COPY config.json /etc/xray/config.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE ${PORT}

CMD ["/entrypoint.sh"]
