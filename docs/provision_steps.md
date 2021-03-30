# Worker server provision

Create folder structure and upload provision_ruby.sh script (skip this steps if
there is a `movebase/current` folder)
```
ssh ubuntu@54.164.74.179 -i ~/config/keys/pems/test-trk-in-rs-us-east-1.pem
mkdir movebase/releases/20201212121212/bin -p
ln -s /home/ubuntu/movebase/releases/20201212121212 /home/ubuntu/movebase/current
scp -i ~/config/keys/pems/test-trk-in-rs-us-east-1.pem  bin/provision_ruby.sh ubuntu@54.164.74.179:movebase/current/bin
```
Run the script

```
ssh ubuntu@54.164.74.179 -i ~/config/keys/pems/test-trk-in-rs-us-east-1.pem
# on remote server
movebase/current/bin/provision_ruby.sh
```
You can repeat upload and run commands if something fails.

Rename hostname so it is easier to see on which machine we are currently (this
will be overwritten by load balancer and launch template)

```
sudo vi /etc/hostname
# type for example staging-worker or staging-app
```

Create a secrets file (if not already exists on shared file system)
`movebase/.rbenv-vars` and link to `~/movebase/.rbenv-vars`
```
vi movebase/.rbenv-vars
# copyand paste `cat config/master.key`
# RAILS_MASTER_KEY=asd123...
# RAILS_ENV=production
```

Deploy to app role will not work since we need to install nginx.

```
cap production deploy
```

# Steps specific to app server NGINX and passenger

```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger focal main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update
sudo apt-get install -y nginx-extras libnginx-mod-http-passenger
if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then sudo ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi
```

You should see nginx page on http://movebase.link/
Now edit passenger configuration to use our ruby
```
sudo vi /etc/nginx/conf.d/mod-http-passenger.conf
passenger_ruby /home/ubuntu/.rbenv/shims/ruby;
```

Use our config for nginx
```
cap production upload:files_f config/etc/nginx/sites-enabled/nginx_passenger
# on remote server
sudo ls -l /etc/nginx/sites-enabled
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /home/ubuntu/movebase/current/config/etc/nginx/sites-enabled/nginx_passenger /etc/nginx/sites-enabled
```

Test and watch logs

```
tail -f /var/log/nginx/*
tail -f movebase/current/log/*
sudo service nginx reload
```

Update domain with you domain that points to staging IP address
```
host movebase.link
```

# Etc configurations: Monit, logrotate

Files that are used for `/etc` on server are stored inside `config/etc` in our
repository. They needs to be sym linked so we keep all configuration inside a
code.

Enable logrotate
```
sudo ln -s /home/ubuntu/movebase/current/config/etc/logrotate.d/movebase /etc/logrotate.d/
```

# SSL with Let's Encrypt

https://certbot.eff.org/lets-encrypt/ubuntufocal-nginx

```
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

sudo snap set certbot trust-plugin-with-root=ok
sudo snap install certbot-dns-route53

sudo snap install --classic aws-cli
```

To create certs we need DNS api access, example policy
https://certbot-dns-route53.readthedocs.io/en/stable/
that you need to attach to your AMI user
```
{
    "Version": "2012-10-17",
    "Id": "certbot-dns-route53 sample policy",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:ChangeResourceRecordSets",
                "route53:GetChange"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}

```

Save AMI user credentials to .ebas_keys
```
# ~/movebase/.elbas_keys
# https://console.aws.amazon.com/iam/home?#/users/dns-challenge
# domain movebase.link
[default]
AWS_ACCESS_KEY_ID=AKIA....
AWS_SECRET_ACCESS_KEY=4N...
```

Generate certificate (use this command when you need to regenerate certificate)
```
sudo su
AWS_CONFIG_FILE=/home/ubuntu/movebase/.elbas_keys certbot certonly --dns-route53 -d movebase.link -d *.movebase.link
```

You can install to nginx configuration (this is done only once and we keep this
in repository, so no need to run this command)
```
# To install to nginx configuration
certbot --nginx -d movebase.link -d *.movebase.link
```
