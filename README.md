# Auto-register-an-EC2-instance-on-Route53
A simple script to auto-register your EC2 instances on Route 53 service.
# Installation
1. First, we need to install cli53 to run this script.
So, download the leatest version from https://github.com/barnybug/cli53/releases/download/ anfd put it in /usr/local
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
chmod a+x /etc/route53/get_ec2_info.sh
chmod a+x /etc/route53/main.sh
```
6. Modify config file according to your needs:
.Insert "Access key ID" and "Secret access key" of dns-editor user created before
.Insert your own DNS zone
