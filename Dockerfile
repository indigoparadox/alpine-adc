
FROM alpine:latest

RUN apk add --no-cache samba-dc krb5 ldb-tools supervisor

EXPOSE 42 53 53/udp 88 88/udp 135 137-138/udp 139 389 389/udp 445 464 464/udp 636 3268-3269 49152-65535

COPY init.sh /

RUN mkdir -p /etc/supervisor.d
COPY etc/samba.ini /etc/supervisor.d/

ENTRYPOINT /init.sh

