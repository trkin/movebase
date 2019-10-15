# What is your Move Index ?

This project aims to make it easier for people search for an event which they
can join for any king of sport or recreational activity. It is an index of all
activities like hiking, running, kayaking, and can perform filtering to specific
discipline requirements like split boarding.

# Docs

You can find additional documentation in

* docs/model.rb

# Installation

This project uses:

* Ruby on Rails https://rubyonrails.org
* Postresql

Gems:

* mobility for translations https://github.com/shioyama/mobility
* Trk datatables for index https://github.com/trkin/trk_datatables

# Development

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

# Slides

Navigate to `/slides`
