# Chat App
- Websockets/Channels

## RUN
```

$ bundle install
$ bundle exec rake db:migrate
$ bundle exec rake db:seed
$ rackup
```

## SPECS & NOTES
- ruby 2.3.0
- sintra
- postgres - production / sqlite3 - development

### Testing
- using rspec 
- can be used with guard & foreman

```
# Automated Testing
$ bundle exec guard

# Also setup with foreman
$ foreman start
```
