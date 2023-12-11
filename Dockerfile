FROM alpine:3@sha256:51b67269f354137895d43f3b3d810bfacd3945438e94dc5ac55fdac340352f48

RUN apk add --no-cache bash coreutils aws-cli gnupg postgresql-client

RUN adduser -D -u 1001 s3-backup

COPY scripts/* /usr/local/bin/

USER 1001
