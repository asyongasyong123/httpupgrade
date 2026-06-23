FROM jthandg/httpupgrade
USER root
COPY config.json /etc/xray/config.json
COPY envoy.yaml /etc/envoy/envoy.yaml
EXPOSE 8080
CMD ["/bin/sh", "-c", "xray run -c /etc/xray/config.json & sleep 4 && exec envoy -c /etc/envoy/envoy.yaml --log-level warn"]
