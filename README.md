# Chat App
- Websockets/Channels
- Join/Create a User & Channel

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
- custom styles


### Testing
- using rspec 
- can be used with guard & foreman

```
# Automated Testing
$ bundle exec guard

# Also setup with foreman
$ foreman start
```

# Hosting
- [Online Here](https://intense-temple-95153.herokuapp.com/)
- Bug occurs on Channel Switch in Chat VIew(looking into)
