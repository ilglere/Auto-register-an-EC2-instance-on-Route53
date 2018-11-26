#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Load configuration
. /etc/route53-cname/config

# Export access key ID and secret for cli53
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

# Use command line scripts to get instance ID and public hostname
INSTANCE_ID=$(ec2metadata | grep 'instance-id:' | cut -d ' ' -f 2)
PUBLIC_HOSTNAME=$(ec2metadata | grep 'public-hostname:' | cut -d ' ' -f 2)
PUBLIC_HOSTNAME_DOT="$PUBLIC_HOSTNAME""." # Adding a dot at the end of the hostname, necessary to create a CNAME record

CNAME_RECORD="$INSTANCE_ID $TTL CNAME $PUBLIC_HOSTNAME_DOT"

# Create a new CNAME record on Route 53, replacing the old entry if nessesary
cli53 rrcreate --replace "$ZONE" "$CNAME_RECORD"
