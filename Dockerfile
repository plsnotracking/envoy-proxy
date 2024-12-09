FROM alpine:3.16
RUN mkdir -p /etc/envoy

RUN apk --no-cache add ca-certificates wget
RUN wget -q -O /etc/apk/keys/devops.spectx.com.rsa.pub https://github.com/Lauri-Nomme/alpine-glibc-xb/releases/download/aarch64-2.33-r0/devops.spectx.com.rsa.pub \
    && wget https://github.com/Lauri-Nomme/alpine-glibc-xb/releases/download/aarch64-2.33-r0/glibc-2.33-r0.apk \
    && wget https://github.com/Lauri-Nomme/alpine-glibc-xb/releases/download/aarch64-2.33-r0/glibc-bin-2.33-r0.apk \
    && apk add glibc-2.33-r0.apk glibc-bin-2.33-r0.apk \
    && rm glibc-2.33-r0.apk glibc-bin-2.33-r0.apk

ADD configs/envoyproxy_io_proxy.yaml /etc/envoy/envoy.yaml
RUN apk add --no-cache shadow su-exec \
        && addgroup -S envoy && adduser --no-create-home -S envoy -G envoy

ARG ENVOY_BINARY_SUFFIX=_stripped
ADD linux/arm64/build_envoy_release${ENVOY_BINARY_SUFFIX}/* /usr/local/bin/

EXPOSE 10000

COPY ci/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["envoy", "-c", "/etc/envoy/envoy.yaml"]

