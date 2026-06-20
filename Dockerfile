FROM alpine:3.20

ENV XRAY_VERSION=1.8.24
ENV PORT=8080

RUN apk update && apk add --no-cache \
    nginx wget unzip ca-certificates tzdata bash

RUN wget -qO /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip && \
    unzip /tmp/xray.zip -d /usr/local/bin/ && \
    rm -f /tmp/xray.zip && \
    chmod +x /usr/local/bin/xray

RUN rm -rf /etc/nginx/conf.d/* /etc/nginx/http.d/*

COPY config.json /etc/xray/config.json
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE ${PORT}

ENTRYPOINT ["/bin/sh", "-c", "sed -i 's/listen 8080;/listen ${PORT};/g' /etc/nginx/nginx.conf && nginx -g 'daemon off;' & exec xray run -c /etc/xray/config.json"]
