FROM alpine:latest

ENV HUGO_VERSION=0.30.2
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /tmp
RUN tar -xf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz -C /tmp \
    && mkdir -p /usr/local/sbin \
    && mv /tmp/hugo /usr/local/sbin/hugo \
    && rm -rf /tmp/hugo_${HUGO_VERSION}_Linux_amd64

ENV HUGO=/usr/local/sbin/hugo
RUN apk update \
    && apk upgrade \
    && apk add --no-cache ca-certificates curl git openssh-client

VOLUME /src
VOLUME /output

ADD https://caddyserver.com/download/linux/amd64?plugins=http.git,http.hugo&license=personal /tmp/caddy_v0.10.10_linux_amd64_custom_personal.tar.gz
RUN mkdir -p /tmp/caddy \
    && tar -xf /tmp/caddy_v0.10.10_linux_amd64_custom_personal.tar.gz -C /tmp/caddy \
    && mv /tmp/caddy /usr/local/sbin/ \
    && rm -rf /tmp/caddy_v0.10.10_linux_amd64_custom_personal.tar.gz
RUN chmod -R 755 /usr/local/sbin/caddy

RUN mkdir -p /srv/output \
    && chmod -R 755 /srv/output

COPY ./Caddyfile /srv/

ENTRYPOINT ["/usr/local/sbin/caddy/caddy"]
CMD ["--conf", "/srv/Caddyfile", "--log", "stdout"]

