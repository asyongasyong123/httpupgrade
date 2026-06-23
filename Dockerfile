FROM teddysun/xray:latest AS xray-bin
FROM envoyproxy/envoy:v1.32-latest

COPY --from=xray-bin /usr/bin/xray /usr/local/bin/xray
COPY config.json /etc/xray/config.json
COPY envoy.yaml /etc/envoy/envoy.yaml

EXPOSE 8080
CMD ["/bin/sh", "-c", "xray run -c /etc/xray/config.json & sleep 5 && exec envoy -c /etc/envoy/envoy.yaml --log-level warn"]
