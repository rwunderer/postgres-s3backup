FROM alpine:3.20@sha256:e72ad0747b9dc266fca31fb004580d316b6ae5b0fdbbb65f17bbe371a5b24cff

RUN apk add --no-cache bash coreutils aws-cli gnupg postgresql-client

RUN adduser -D -u 1001 s3-backup

COPY scripts/* /usr/local/bin/

USER 1001
