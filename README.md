# certbot-route53-ucp
This docker image uses the [certbot-route53 image](https://hub.docker.com/r/ntcnvisia/certbot-route53/) to obtain signed keys from Let's Encrypt and places them in the correct volume for your DDC UCP server

[Docker Hub link](https://hub.docker.com/r/ntcnvisia/certbot-route53-ucp/)

## Important UCP Installation Note:
Don't forget to use the **--external-server-cert** flag when installing UCP.

### Example
```
docker run -e "DOMAIN=[YOUR DOMAIN]" -e "EMAIL=[YOUR EMAIL]" -e "AWS_ACCESS_KEY_ID=[YOUR AWS KEY]" -e "AWS_SECRET_ACCESS_KEY=[YOUR AWS SECRET KEY]" -e "AWS_DEFAULT_REGION=[YOUR AWS REGION]" -e "TZPATH=America/Chicago" -v certbot-route53-letsencrypt:/etc/letsencrypt -v ucp-controller-server-certs:/var/ucp-certs ntcnvisia/certbot-route53-ucp
```

### Required Volumes
You should create a pair of named volumes (`volume create --name [YOUR VOLUME NAME]`).
The first volume must be mapped to /etc/letsencrypt - this is the folder certbot uses to store certificates and other configuration data required for renewal.
The second volume must be named *ucp-controller-server-certs* and must be mapped to /var/ucp-certs - this is the volume that UCP will use

### Runtime Configuration
This image is configured using the following environment variables:

Variable Name | Purpose
------------- | -------
DOMAIN | Comma separated list of domains to request a single certificate for.
EMAIL | Administrator email for Let's Encrypt recovery purposes.
TZPATH | Name of the timezone to use for the container. This must match the host for AWS request signing to work! This must be a standard name ie: America/Chicago as it's used as a part of the /usr/share/zoneinfo/ path.
FORCERENEWAL | If this variable is defined, the [--force-renewal flag][re-run-certbot] will be applied to certbot. This forces a certificate update.
EXPAND | If this variable is defined, the [--expand flag][re-run-certbot] will be applied to certbot. This allows SAN names to be added to an existing certificate.
AWS_ACCESS_KEY_ID | AWS-provided access key. Must have permissions for Route53 in the correct zone. See policy information below
AWS_SECRET_ACCESS_KEY | AWS-provided secret key. Must have permissions for Route53 in the correct zone. See policy information below
AWS_DEFAULT_REGION | AWS Region to use for Route53 access.
STAGING | If this variable is set at all, hit the Let's Encrypt Staging environment instead of the real one. Only use this for testing, as the certificates will not be valid.

### AWS Policy Information
You will want to create a separate AWS account and policy with limited permissions for Route53 where the hosted zonefile is limited to the subdomains you want certificates for.

Example policy:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:GetChange",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/[YOUR ZONEFILE ID HERE]"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:GetChange"
            ],
            "Resource": [
                "arn:aws:route53:::change/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHealthChecks",
                "route53:ListHostedZones",
                "route53:ListHostedZonesByName"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```

[re-run-certbot]:https://certbot.eff.org/docs/using.html#re-running-certbot
