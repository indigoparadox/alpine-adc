
FROM alpine:latest

RUN apk add --no-cache samba-dc krb5

ENTRYPOINT sleep infinity

