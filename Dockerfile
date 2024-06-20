FROM alpine:3.20@sha256:5f48f60d043e6df88720dea5f954dcf507912368cd84bd08703325fdf269724e

RUN apk add --no-cache bash coreutils aws-cli gnupg postgresql-client

RUN adduser -D -u 1001 s3-backup

COPY scripts/* /usr/local/bin/

USER 1001
