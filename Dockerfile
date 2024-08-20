FROM alpine:3.20 AS builder

ARG TARGET_VERSION  \
    TARGET_FILE

RUN mkdir -p /build && \
    apk add --no-cache wget && \
    wget -q -O /build/miniooni \
    "https://github.com/ooni/probe-cli/releases/download/$TARGET_VERSION/miniooni-$TARGET_FILE" && \
    chmod +x /build/miniooni

FROM alpine:3.20

COPY --from=builder /build/miniooni /.miniooni/miniooni
COPY ./scripts/probe.sh /.miniooni/probe.sh

RUN chmod +x /.miniooni/probe.sh

ENTRYPOINT ["/bin/sh", "/.miniooni/probe.sh"]