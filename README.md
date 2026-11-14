# docker-webhook

[![github-actions](https://github.com/theohbrothers/docker-webhook/actions/workflows/ci-master-pr.yml/badge.svg?branch=master)](https://github.com/theohbrothers/docker-webhook/actions/workflows/ci-master-pr.yml)
[![github-release](https://img.shields.io/github/v/release/theohbrothers/docker-webhook?style=flat-square)](https://github.com/theohbrothers/docker-webhook/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/theohbrothers/docker-webhook/latest)](https://hub.docker.com/r/theohbrothers/docker-webhook)

Dockerized [`webhook`](https://github.com/adnanh/webhook) with useful tools.

## Tags

| Tag | Dockerfile Build Context |
|:-------:|:---------:|
| `:2.8.3`, `:latest` | [View](variants/2.8.3) |
| `:2.8.3-libvirt-12` | [View](variants/2.8.3-libvirt-12) |
| `:2.8.3-curl-git-jq-sops-ssh` | [View](variants/2.8.3-curl-git-jq-sops-ssh) |
| `:2.8.3-libvirt-11` | [View](variants/2.8.3-libvirt-11) |
| `:2.8.3-curl-git-jq-sops-ssh` | [View](variants/2.8.3-curl-git-jq-sops-ssh) |
| `:2.8.3-libvirt-10` | [View](variants/2.8.3-libvirt-10) |
| `:2.8.3-curl-git-jq-sops-ssh` | [View](variants/2.8.3-curl-git-jq-sops-ssh) |
| `:2.8.3-libvirt-9` | [View](variants/2.8.3-libvirt-9) |
| `:2.8.3-curl-git-jq-sops-ssh` | [View](variants/2.8.3-curl-git-jq-sops-ssh) |
| `:2.8.3-libvirt-8` | [View](variants/2.8.3-libvirt-8) |
| `:2.8.3-curl-git-jq-sops-ssh` | [View](variants/2.8.3-curl-git-jq-sops-ssh) |
| `:2.8.3-libvirt-7` | [View](variants/2.8.3-libvirt-7) |
| `:2.8.3-libvirt-6` | [View](variants/2.8.3-libvirt-6) |
| `:2.7.0` | [View](variants/2.7.0) |
| `:2.7.0-libvirt-12` | [View](variants/2.7.0-libvirt-12) |
| `:2.7.0-curl-git-jq-sops-ssh` | [View](variants/2.7.0-curl-git-jq-sops-ssh) |
| `:2.7.0-libvirt-11` | [View](variants/2.7.0-libvirt-11) |
| `:2.7.0-curl-git-jq-sops-ssh` | [View](variants/2.7.0-curl-git-jq-sops-ssh) |
| `:2.7.0-libvirt-10` | [View](variants/2.7.0-libvirt-10) |
| `:2.7.0-curl-git-jq-sops-ssh` | [View](variants/2.7.0-curl-git-jq-sops-ssh) |
| `:2.7.0-libvirt-9` | [View](variants/2.7.0-libvirt-9) |
| `:2.7.0-curl-git-jq-sops-ssh` | [View](variants/2.7.0-curl-git-jq-sops-ssh) |
| `:2.7.0-libvirt-8` | [View](variants/2.7.0-libvirt-8) |
| `:2.7.0-curl-git-jq-sops-ssh` | [View](variants/2.7.0-curl-git-jq-sops-ssh) |
| `:2.7.0-libvirt-7` | [View](variants/2.7.0-libvirt-7) |
| `:2.7.0-libvirt-6` | [View](variants/2.7.0-libvirt-6) |

- All variants contain [`ts`](https://viric.name/soft/ts/) to help run background tasks.

## Usage

```sh
# Create hooks.yml, see: https://github.com/adnanh/webhook#configuration
cat - > hooks.yml <<'EOF'
- id: hello-world
  execute-command: echo
EOF

# Start container
docker run -it -p 9000:9000 -v $(pwd)/hooks.yml:/config/hooks.yml:ro theohbrothers/docker-webhook

# Run the webhook
wget -qO- "http://$HOSTNAME:9000/hooks/hello-world"
```

## FAQ

### Q: `webhook` fails with error `__nanosleep_time64: symbol not found`

On Raspberry Pi, running `alpine-3.12` fails with error:

```sh
$ docker run -it theohbrothers/docker-webhook:2.8.0-alpine-3.12
Error relocating /usr/local/bin/webhook: __nanosleep_time64: symbol not found
```

The solution is to use `alpine-3.13` or later

```sh
$ docker run -it theohbrothers/docker-webhook:2.8.0-alpine-3.13
```

### Q: `ping` fails with error `ping: clock_gettime(MONOTONIC) failed`

On Raspberry Pi, running `ping` on `alpine-3.13` and above might fail with error:

```sh
$ docker run -it theohbrothers/docker-webhook:2.8.0-alpine-3.13
PING 1.1.1.1 (1.1.1.1): 56 data bytes
ping: clock_gettime(MONOTONIC) failed
```

The solution is to use `--security-opt seccomp=unconfined` option. See [here](https://gitlab.alpinelinux.org/alpine/aports/-/issues/12091)

```sh
$ docker run -it --security-opt seccomp=unconfined theohbrothers/docker-webhook:2.8.0-alpine-3.13
```

## Development

Requires Windows `powershell` or [`pwsh`](https://github.com/PowerShell/PowerShell).

```powershell
# Install Generate-DockerImageVariants module: https://github.com/theohbrothers/Generate-DockerImageVariants
Install-Module -Name Generate-DockerImageVariants -Repository PSGallery -Scope CurrentUser -Force -Verbose

# Edit ./generate templates

# Generate the variants
Generate-DockerImageVariants .
```
