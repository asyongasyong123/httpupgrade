FROM teddysun/xray:latest AS xray
FROM envoyproxy/envoy:v1.32-latest

COPY --from=xray /usr/bin/xray /usr/local/bin/xray
COPY config.json /etc/xray/config.json
COPY envoy.yaml /etc/envoy/envoy.yaml

RUN chmod +x /usr/local/bin/xray

EXPOSE 8080

# Wait until Xray is actually listening before starting Envoy
CMD ["/bin/sh", "-c", "xray run -c /etc/xray/config.json & \
until nc -z 127.0.0.1 10000; do sleep 0.5; done; \
sleep 2; \
exec envoy -c /etc/envoy/envoy.yaml --log-level warn"]
