#!/bin/sh

LEPATH=/etc/letsencrypt/live/$DOMAIN

if [ -d $LEPATH ];
then
    cp $LEPATH/privkey.pem /var/ucp-certs/key.pem
    cp $LEPATH/fullchain.pem /var/ucp-certs/cert.pem
    python /root/certbot-route53/getIdenTrustCa.py
    echo "Copied files from $LEPATH to /var/ucp-certs" >&2
else
    echo "ERROR! Live domain directory not found at $LEPATH" >&2
fi