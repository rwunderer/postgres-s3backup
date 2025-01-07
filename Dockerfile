FROM alpine:3.21@sha256:b97e2a89d0b9e4011bb88c02ddf01c544b8c781acf1f4d559e7c8f12f1047ac3

RUN apk add --no-cache bash coreutils aws-cli gnupg postgresql-client

RUN adduser -D -u 1001 s3-backup

COPY scripts/* /usr/local/bin/

USER 1001
