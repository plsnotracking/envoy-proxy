FROM alpine:3.16
RUN mkdir -p /etc/envoy

RUN apk --no-cache add ca-certificates wget gcompat libstdc++

ADD configs/envoyproxy_io_proxy.yaml /etc/envoy/envoy.yaml
RUN apk add --no-cache shadow su-exec \
        && addgroup -S envoy && adduser --no-create-home -S envoy -G envoy

ARG ENVOY_BINARY_SUFFIX=_stripped
ADD linux/arm64/build_envoy_release${ENVOY_BINARY_SUFFIX}/* /usr/local/bin/

EXPOSE 10000

COPY ci/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["envoy", "-c", "/etc/envoy/envoy.yaml"]

