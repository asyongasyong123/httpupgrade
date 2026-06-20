FROM alpine:latest

ENV PORT=8080

# Add Xray repo first
RUN apk add --no-cache ca-certificates && \
    curl -fsSL https://dl.lamp.sh/v2ray/xray.repo > /etc/apk/repositories.d/xray.list && \
    wget -qO /etc/apk/keys/xray.rsa.pub https://dl.lamp.sh/v2ray/xray.rsa.pub && \
    apk update && \
    apk add --no-cache xray nginx bash

COPY config.json /etc/xray/config.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE ${PORT}

CMD ["/entrypoint.sh"]
