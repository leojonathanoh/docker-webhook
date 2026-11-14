FROM golang:1.24-alpine as builder
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

RUN set -eux; \
    apk add --no-cache git; \
    git clone https://github.com/adnanh/webhook.git /src --branch 2.8.3; \
    cd /src; \
    go build -ldflags="-s -w" -o /usr/local/bin/webhook;

FROM alpine:3.24
COPY --from=builder /usr/local/bin/webhook /usr/local/bin/webhook
RUN webhook --version

RUN apk add --no-cache ca-certificates

# Install Task Spooler
RUN apk add --no-cache ts

RUN apk add --no-cache curl
RUN apk add --no-cache git
RUN apk add --no-cache jq
# Install sops
RUN set -eux; \
    SOPS_VERSION=3.13.3; \
    case "$( uname -m )" in \
        'x86_64') \
            URL="https://github.com/getsops/sops/releases/download/v3.13.3/sops-v3.13.3.linux.amd64"; \
            SHA256=e5bec3346a873ae91d871550f3e698c1aad962aff462a080e40f25fde17fef6b; \
            ;; \
        'aarch64') \
            URL="https://github.com/getsops/sops/releases/download/v3.13.3/sops-v3.13.3.linux.arm64"; \
            SHA256=53b0abacd38ef1b12a66d6c100956691b9cefce018d91f81e73ddf7438b94d77; \
            ;; \
        *) \
            URL="https://github.com/getsops/sops/releases/download/v3.13.3/sops-v3.13.3.linux.amd64"; \
            SHA256=e5bec3346a873ae91d871550f3e698c1aad962aff462a080e40f25fde17fef6b; \
            ;; \
    esac; \
    FILE=sops; \
    wget -q "$URL" -O "$FILE"; \
    echo "$SHA256  $FILE" | sha256sum -c -; \
    BIN=sops; \
    mkdir -pv /usr/local/bin; \
    mv -v "$BIN" /usr/local/bin/sops; \
    chmod +x /usr/local/bin/sops; \
    sops --version --disable-version-check; \
    :

# Install gnupg for sops
RUN apk add --no-cache gnupg

RUN apk add --no-cache openssh-client
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

WORKDIR /config
ENTRYPOINT [ "/docker-entrypoint.sh" ]
EXPOSE 9000
CMD [ "-verbose", "-hooks=/config/hooks.yml", "-hotreload" ]
