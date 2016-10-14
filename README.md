# Chat App
- demonstrating different ways to make chat applications using ruby/sinatra/javascript

## RUN
```
$ bundle install
$ rackup
```

## SPECS & NOTES
- Original Manual Reload can be found in branch: feature_manual_reload
- ruby 2.3.0
- sintra
- styles = Bootstrap/Jquery - CDN / Custom CSS
- currently stores data via CSV
- deployed to heroku via production branch

### Manual Reload
- page refreshes when message is submited
- posts message, then refreshes page

### Live Reload
- javascript is constantly polling for new data and updating view

### Websockets
- uses websockets for chat(no page refresh or constant requests for server)
- look into keeping sockets open on heroku
- setup for https