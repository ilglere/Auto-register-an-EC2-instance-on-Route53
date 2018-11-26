# Auto-register-an-EC2-instance-on-Route53
This script allows you to automatically register a CNAME record, on Route 53, with the public DNS (IPv4) of your instance.

Are you are searching for a method to access to your instances by pointing to a static DNS record, without using an Elastic IP? Well, this script is made for you!

You will be able to access to your instances by point to: instance_name.my.zone.dns (instead of: ec2-xxx-xxx-xxx-xxx.eu-west-1.compute.amazonaws.com). Where "xxx-xxx-xxx-xxx" is the dynamic public IP.
# Pre-requisites
First of all we need to create an IAM user, with an associated policy.
1. Create a new IAM group called "dns-editor-group" (or whatever you want)
2. Create a new IAM policy called "dns-editor-policy" (or whatever you want) attaching this JSON (where <Your zone ID> is your ID of the DNS zone on Route 53):
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:GetHostedZone",
                "route53:ListResourceRecordSets"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:route53:::hostedzone/<Your zone ID>"
            ]
        },
        {
            "Action": [
                "route53:ListHostedZonesByName"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        }
    ]
}
```
3. Create a new IAM user called "dns-editor" (or whatever you want) and remember to download its credentials and store them in a save place.

Now we are ready to download and config the script.
# Installation
1. First, we need to install cli53 to run this script.
So, download the leatest version from https://github.com/barnybug/cli53/releases/download/ anfd put it in /usr/local (on the examples below I downloaded version 0.8.12 for linux-amd64)
```
cd /usr/local/
wget https://github.com/barnybug/cli53/releases/download/0.8.12/cli53-linux-amd64
```
2. Chown it using root and chmod it with 700
```
chown root:root /usr/local/cli53-linux-amd64
chmod 700 /usr/local/cli53-linux-amd64
```
3. Create a link to /usr/bin
```
ln /usr/local/cli53-linux-amd64 /usr/bin
```
4. Create a new folder called route53 in /etc/ , and download this repo
```
mkdir /etc/route53
git clone https://github.com/ilglere/Auto-register-an-EC2-instance-on-Route53.git
mv Auto-register-an-EC2-instance-on-Route53/* ./*
```
5. Modify permissions to config file and make .sh scripts execitables
```
chmod 600 /etc/route53/config
chmod a+x /etc/route53/register_cname_route53.sh
```
6. Modify config file according to your needs: (insert "Access key ID" and "Secret access key" of dns-editor user created before & insert your own DNS zone)
7. Create a link of main.sh script to /etc/dhcp/dhclient-exit-hooks.d/
```
ln /etc/route53/register_cname_route53.sh /etc/dhcp/dhclient-exit-hooks.d/update-route53-dns
```
8. Modify crontab for running main.sh script when instance boots up.
```
corntab -e
@reboot ln /etc/route53/register_cname_route53.sh
```
