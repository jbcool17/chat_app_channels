# Chat App
- Demonstrating different ways to make chat applications using ruby/javascript
- Original Manual Reload style can be found in branch: feature_manual_reload

## RUN
```
$ bundle install
$ rackup
```

## SPECS & NOTES
- ruby 2.3.0
- sintra
- postgres - production / sqlite3 - development
- deployed to heroku via production branch - [Online Here](https://morning-island-89210.herokuapp.com/)
- styles = Bootstrap/Jquery - CDN / Custom CSS
- started to use react for views(setup on home page)
- random color per user is working, needs to be tweeked

### Testing
- using rspec 
- can be used with guard & foreman

```
# Automated Testing
$ bundle exec guard

# Also setup with foreman
$ foreman start
```

### Manual Reload
- page refreshes when message is submited
- posts message, then refreshes page

### Live Reload
- javascript is constantly polling for new data and updating view

### Websockets
- uses websockets for chat(no page refresh or constant requests for server)
- look into keeping sockets open on heroku
- setup for https
