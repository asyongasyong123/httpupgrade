FROM teddysun/xray:latest AS xray
FROM envoyproxy/envoy:v1.32-latest

COPY --from=xray /usr/bin/xray /usr/local/bin/xray
COPY config.json /etc/xray/config.json
COPY envoy.yaml /etc/envoy/envoy.yaml

RUN chmod +x /usr/local/bin/xray

EXPOSE 8080

CMD ["/bin/sh", "-c", "xray run -c /etc/xray/config.json & sleep 10 && exec envoy -c /etc/envoy/envoy.yaml --log-level warn"]
