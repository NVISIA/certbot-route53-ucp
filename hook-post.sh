#!/bin/sh

LEPATH=/etc/letsencrypt/live/$DOMAIN

if [ -d $LEPATH ];
then
    cp $LEPATH/privkey.pem /var/ucp-certs/key.pem
    cp $LEPATH/fullchain.pem /var/ucp-certs/cert.pem
    wget -O /var/ucp-certs/ca.pem https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem
    echo "Copied files from $LEPATH to /var/ucp-certs" >&2
else
    echo "ERROR! Live domain directory not found at $LEPATH" >&2
fi