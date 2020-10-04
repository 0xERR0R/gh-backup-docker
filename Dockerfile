FROM alpine

LABEL org.opencontainers.image.source="https://github.com/0xERR0R/gh-backup-docker" \
      org.opencontainers.image.url="https://github.com/0xERR0R/gh-backup-docker" \
      org.opencontainers.image.title="GitHub backup"

RUN apk add --no-cache \
    py3-pip \
    bash \
    zip \
    git && \
    pip3 install github-backup

COPY backup.sh /opt/backup.sh

VOLUME /out

ENTRYPOINT /opt/backup.sh
