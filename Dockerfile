FROM ntc/certbot-route53
MAINTAINER dlee@nvisia.com

VOLUME /var/ucp-certs

COPY hook-post.sh /root/certbot-route53/hook-post.sh

RUN chmod +x /root/certbot-route53/hook-post.sh

ENTRYPOINT ["/root/certbot-route53/main.sh"]
