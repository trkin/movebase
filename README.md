# What is your Move Index ?

This project aims to make it easier for people search for an event which they
can join for any king of sport or recreational activity. It is an index of all
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

Pull production data with
```
rails db:drop
heroku pg:pull postgresql-curly-88828 move_index_development
```

Secrets are stored in `config/credentials/development.yml.erb` and you can edit
with

```
rails credentials:edit -e development
```

Icons

```
gnome-open https://localhost:3000/fontello-demo.html
# when you want to update you can
fontello open
# select new icons
bundle exec fontello convert
```

I18n uses following locale files

```
config/locales/*
app/javascript/locales/*
app/javascript/const.js
```

Use helpers to translate
```
yml_google_translate_api.rb config/locales/sr-latin.yml sr_to_cyr en
```

# Tests

Run tests with `rake`

# Production

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
