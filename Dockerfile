FROM alpine:3.23@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

RUN apk add --no-cache bash coreutils aws-cli gnupg postgresql-client

RUN adduser -D -u 1001 s3-backup

COPY scripts/* /usr/local/bin/

USER 1001
