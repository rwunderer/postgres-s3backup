FROM alpine:3.23@sha256:c69a6ff7c24d1ffa913798501d0e7104e0e9764e28eb44a930939f91ef829e64

RUN apk add --no-cache bash coreutils aws-cli gnupg postgresql-client

RUN adduser -D -u 1001 s3-backup

COPY scripts/* /usr/local/bin/

USER 1001
