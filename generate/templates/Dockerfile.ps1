@"
FROM golang:1.24-alpine as builder
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on `$BUILDPLATFORM, building for `$TARGETPLATFORM"

RUN set -eux; \
    apk add --no-cache git; \
    git clone https://github.com/adnanh/webhook.git /src --branch $( $VARIANT['_metadata']['package_version'] ); \
    cd /src; \
    go build -ldflags="-s -w" -o /usr/local/bin/webhook;

FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] )
COPY --from=builder /usr/local/bin/webhook /usr/local/bin/webhook
RUN webhook --version

RUN apk add --no-cache ca-certificates

# Install Task Spooler
RUN apk add --no-cache ts


"@

$VARIANT['_metadata']['components'] | % {
    $component = $_

    switch( $component ) {
        'curl' {
            @"
RUN apk add --no-cache curl

"@
        }

        'git' {
            @"
RUN apk add --no-cache git

"@
        }

        'jq' {
            @"
RUN apk add --no-cache jq

"@
        }

        { $_ -match 'libvirt-\d+' } {
    @"
RUN apk add --no-cache libvirt-client

"@
        }

        'sops' {
            $SOPS_VERSION = "3.13.3"
            Generate-DownloadBinary @{
                binary = 'sops'
                version = $SOPS_VERSION
                checksumsUrl = "https://github.com/getsops/sops/releases/download/v$SOPS_VERSION/sops-v$SOPS_VERSION.checksums.txt"
                platformFallback = 'linux/amd64'
                destination = '/usr/local/bin/sops'
                testCommand = 'sops --version --disable-version-check'
            }

            @"
# Install gnupg for sops
RUN apk add --no-cache gnupg


"@
        }

        'ssh' {
            @"
RUN apk add --no-cache openssh-client

"@
        }

        'bare' {}

        default {
            throw "No such component: $component"
        }
    }
}

@"
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

WORKDIR /config
ENTRYPOINT [ "/docker-entrypoint.sh" ]
EXPOSE 9000
CMD [ "-verbose", "-hooks=/config/hooks.yml", "-hotreload" ]

"@
