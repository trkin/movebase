# What is your Move ?

This project aims to make it easier for people search for an event which they
can join for any kind of sport or recreational activity. It is an index of all
activities like hiking, running, kayaking, and can perform filtering to specific
discipline requirements like split boarding.

Source is located on https://github.com/trkin/move-index

# Docs

You can find additional documentation in

* docs/model.rb

# Installation

This project uses:

* Ruby on Rails
* Postresql
* Github Actions CI/CD to deploy to Digital Ocean

Gems:

* mobility for translations https://github.com/shioyama/mobility
* Trk datatables for basic listing and searching
  https://github.com/trkin/trk_datatables

# Development

Download the source, install dependencies and run rails server
```
git clone git@github.com:trkin/movebase.git
cd movebase
bundle
yarn
rails db:setup
rails s
```

Pull production data with
```
rails db:drop
heroku pg:pull postgresql-curly-88828 movebase_development
```

Secrets are stored in `config/credentials/development.yml.erb` and you can edit
with

```
rails credentials:edit -e development
```

Icons

```
xdg-open http://localhost:3002/fontello-demo.html
# when you want to update you can
fontello open
# select new icons
bundle exec fontello convert
```
Use in html like
```
<i class="demo-icon icon-menu"></i>
```

I18n uses following locale files

```
config/locales/*
app/javascript/locales/*
app/javascript/const.js
```

Use helpers to translate
```
yml_google_translate_api.rb config/locales/sr-latin.yml sr_to_cyr en_humanize
yml_google_translate_api.rb config/locales/activerecord_activemodels.sr-latin.yml sr_to_cyr en_humanize
```

# Capistrano

Here are some example tasks:

```
cap production rails:logs
```

# SSL

Free https ssl certificate is obtained using Let's encrypt.
You can find a command that is used for renewal

```
cat /etc/cron.d/certbot
sudo AWS_CONFIG_FILE=/home/ubuntu/movebase/.elbas_keys certbot -q renew
```
See logs `less /var/log/syslog` or `vi /var/log/letsencrypt/letsencrypt.log`

# Tests

Run integration and other non browser tests


Here are some example tasks:

```
cap production rails:logs
```

# Tests

Run integration and other non browser tests

```
rake
# run specific test
rails test test/controllers/devise/my_registrattions_controller_test.rb:6
```
Run system tests (in chrome browser). Enable headfull chrome in
`test/application_system_test_case.rb`

```
rails test:system
# run specific test
rails test test/system/links_test.rb:40
```

# Production

Terraform on AWS ECS

State file `terraform/terraform.tfstate` is in S3.
We use env from `config/keys/movebase.sh`
```
export TF_VARS_DB_PASSWORD = ""
```
and store key in `config/keys/my

Make sure you can access production server
```
ssh root@$PRODUCTION_IP
ssh deploy@$PRODUCTION_IP
```

Creating new Release (with tag like `v0.123`) will trigger production deploy,
but you can manually deploy using:

```
cap production deploy
```

# Slides

Navigate to `/slides`
