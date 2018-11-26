#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Load configuration
. /etc/route53/config

# Export access key ID and secret for cli53
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

# Use command line scripts to get instance ID and public hostname
INSTANCE_ID=$(ec2metadata | grep 'instance-id:' | cut -d ' ' -f 2)
PUBLIC_HOSTNAME=$(ec2metadata | grep 'public-hostname:' | cut -d ' ' -f 2)
PUBLIC_HOSTNAME_DOT="$PUBLIC_HOSTNAME""." # Adding a dot at the end of the hostname, necessary to create a CNAME record

# Create a new CNAME record on Route 53, replacing the old entry if nessesary
## This akward code is necessary to pass variables to cli53 command, otherwise you'll get syntax error
cp /etc/route53/get_ec2_info.sh /etc/route53/run_cli53.sh
echo "cli53 rc --replace $ZONE '$INSTANCE_ID $TTL $TYPE $PUBLIC_HOSTNAME_DOT'" >> /etc/route53/run_cli53.sh
chmod a+x /etc/route53/run_cli53.sh
/etc/route53/run_cli53.sh
