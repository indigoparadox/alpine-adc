#!/bin/bash

openssl req -x509 -newkey rsa:4096 \
	-keyout key.pem -nodes -out cert.pem \
	-days 36500 \
	-config tls-gen.conf \
	-addext keyUsage=digitalSignature -addext extendedKeyUsage=serverAuth

cp cert.pem ca.pem

