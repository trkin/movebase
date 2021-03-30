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
passenger_ruby /home/deploy/.rbenv/shims/ruby;
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
sudo service puma status
sudo service puma stop
sudo service puma start
```

Update domain with you domain that points to staging IP address
```
host new-staging.trk.in.rs
# new-staging.trk.in.rs has address 13.250.12.234
```

For first time database usage we need to create database. You can use rake task
on remote server
```
bin/upload.sh staging-app -ssh
cd movebase/current
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails db:drop
```

or capistrano task (defined in `lib/capistrano/tasks/db.rake`)
```
cap staging db:create
cap staging db:seed
```

or you can create database manually in mysql console

```
mysql -h xn01-db-test-01.cwmyzdhrblhe.ap-southeast-1.rds.amazonaws.com -u admin -p

CREATE DATABASE web001db;
\q
```

In console update isp domain
```
bundle exec rails c
i=UnscopedIsp.first
i.domain='trk.in.rs'
i.subdomain_for_admin='new-staging'
i.save!
```


Error for missing webpacker manifest
```
F, [2021-01-15T20:44:28.594955 #8433] FATAL -- : [9db90437-11d3-4c0b-a373-6af670f5aaa5] ActionView::Template::Error (Webpacker can't find application in /home/ubuntu/movebase/releases/20210115204251/public/packs/manifest.json. Possible causes:
```
than you should update some assets, for example
`app/javascript/packs/application.js` and deploy again.



# Etc configurations: Monit, logrotate

Files that are used for `/etc` on server are stored inside `config/etc` in our
repository. They needs to be sym linked so we keep all configuration inside a
code.
Monit configuration files are stored in `config/etc/monit/conf-enabled` folder
which includes other files. For smtp we need to use gmail password so that
configuration is manually created on server in `movebase/.monit_mailserver`
(along with `movebase/.rbenv-vars`) so we do not store password in a code.

```
vi ~/movebase/.monit_mailserver
# This is a file with a smtp username and password and should be linked to
# ln -s /home/ubuntu/movebase/.monit_mailserver /home/ubuntu/movebase/
set mailserver
  smtp.gmail.com port 587
  username info@movebase.com password <GMAIL_PASSWORD>
  using tlsv13
ln -s /home/ubuntu/movebase/.monit_mailserver /home/ubuntu/movebase/
```

To enable monit we need to link to our configuration

```
sudo ls /etc/monit/conf-enabled
# there should not be any files or links
sudo ln -s /home/ubuntu/movebase/current/config/etc/monit/conf-enabled/staging-app /etc/monit/conf-enabled
```

You can restart service
```
sudo service monit force-reload
```
and check configuration with verbose option
```
sudo monit -v
sudo monit summary
sudo monit status
sudo monit stop delayed_job_0
sudo monit unmonitor delayed_job_0
```
Watch logs and monit webserver using
```
bin/upload.sh staging-app -tunel
tail -f movebase/current/log/monit.log
```
and open the browser on http://localhost:8812

Enable logrotate
```
sudo ln -s /home/ubuntu/movebase/current/config/etc/logrotate.d/movebase /etc/logrotate.d/
```

Delay times total is 90 seconds (1min and 30s)
* 45-50 seconds to boot the machine (`tail -f movebase/current/log/monit.log`
  look for stopped and starting events) curl will respoond with Failed to
  connect: Connection refused
* movebase puma 40 seconds (we set start delay in monit, next check is after 60
  seconds), curl will respond with 502 Bad Gateway

We use `config/scheduler.rb` to define crontab and currently there are some jobs
that needs to be performed in India Timezone so we need to change bash timezone
```
sudo dpkg-reconfigure tzdata
# select Asia/Kolkata
```
Create `log/cron` folder
```
mkdir /home/ubuntu/movebase/current/log/cron
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

Generate certificate
```
sudo su
AWS_CONFIG_FILE=/home/ubuntu/movebase/.elbas_keys certbot certonly --dns-route53 -d *.movebase-test-01.com -d *.movebasei.in

# production
AWS_CONFIG_FILE=/home/ubuntu/movebase/.elbas_keys certbot certonly --dns-route53 -d *.movebase.com -d *.movebasedemo.com -d *.movebasei.com
```

Uploading to ACM (we need AWSCertificateManagerFullAccess permissions)
```
sudo su
cd /etc/letsencrypt/live/movebase-test-01.com
AWS_CONFIG_FILE=/home/ubuntu/movebase/.elbas_keys aws acm import-certificate --certificate fileb://cert.pem --certificate-chain fileb://chain.pem --private-key fileb://privkey.pem
# this commands returns ARN which we have to use to set up NLB certificate
# you can find arn with AWS_CONFIG_FILE=/home/ubuntu/movebase/.elbas_keys aws acm list-certificates
{
    "CertificateArn": "arn:aws:acm:us-east-1:219232999684:certificate/369b84d6-4527-49ed-8fc1-27004561f4da"
}

# production
{
    "CertificateArn": "arn:aws:acm:ap-southeast-1:664559194543:certificate/f8dc4cdb-fdc4-4256-863a-7b325b44f746"
}
```

Using CertificateArn we set NLB certificate (we need AmazonEC2FullAccess)
```
# list load balancers (find LoadBalancerArn)
AWS_CONFIG_FILE=/home/ubuntu/movebase/.elbas_keys aws elbv2 describe-load-balancers
# list listeners for specific LoadBalancerArn and find ListenerArn
AWS_CONFIG_FILE=/home/ubuntu/movebase/.elbas_keys aws elbv2 describe-listeners --load-balancer arn:aws:elasticloadbalancing:ap-southeast-1:664559194543:loadbalancer/net/nlb-xn01-staging-app/2eeadfa12e1e223b

# set certificate for specific ListenerArn arn:aws:elasticloadbalancing:ap-southeast-1:664559194543:listener/net/nlb-xn01-staging-app/2eeadfa12e1e223b/902a07e1e6c1cf79
AWS_CONFIG_FILE=/home/ubuntu/movebase/.elbas_keys aws elbv2 add-listener-certificates --listener-arn arn:aws:elasticloadbalancing:ap-southeast-1:664559194543:listener/net/nlb-xn01-staging-app/2eeadfa12e1e223b/902a07e1e6c1cf79 --certificates CertificateArn=arn:aws:acm:ap-southeast-1:664559194543:certificate/99d4ed43-e26a-4ef7-9ed4-384db0228b24

# check certificates for listener
AWS_CONFIG_FILE=/home/ubuntu/movebase/.elbas_keys aws elbv2 describe-listener-certificates --listener-arn arn:aws:elasticloadbalancing:ap-southeast-1:664559194543:listener/net/nlb-xn01-staging-app/2eeadfa12e1e223b/902a07e1e6c1cf79


# production

```
# Seed database

To create a dump which can be used to insert movebase users you can use:
```
mysqldump -h xn01-db01.cwmyzdhrblhe.ap-southeast-1.rds.amazonaws.com -u web001dbuser -p web001db users --where 'id IN (select user_id from movebase_users)' --single-transaction --no-create-info --insert-ignore --set-gtid-purged=OFF > users.sql
mysqldump -h xn01-db01.cwmyzdhrblhe.ap-southeast-1.rds.amazonaws.com -u web001dbuser -p web001db movebase_users --single-transaction --no-create-info --insert-ignore --set-gtid-purged=OFF >> users.sql
mysqldump -h xn01-db01.cwmyzdhrblhe.ap-southeast-1.rds.amazonaws.com -u web001dbuser -p web001db user_profiles --where 'user_id IN (select user_id from movebase_users)' --single-transaction --no-create-info --insert-ignore --set-gtid-purged=OFF >> users.sql

bin/upload.sh staging-worker users.sql -ssh
# file should be stored on `~/movebase/shared/users.sql`
mv movebase/current/users.sql movebase/shared/
```

Invoke with capistrano `cap production db:load_movebase_users`

