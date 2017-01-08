# chat-app-channels

[![standard-readme compliant](https://img.shields.io/badge/standard--readme-OK-green.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme) [![Stories in Progress](https://badge.waffle.io/jbcool17/chat_app_channels.svg?label=In%20Progress&title=In%20Progress)](http://waffle.io/jbcool17/chat_app_channels) [![Stories in Ready](https://badge.waffle.io/jbcool17/chat_app_channels.svg?label=ready&title=Ready)](http://waffle.io/jbcool17/chat_app_channels) [![Stories in Done](https://badge.waffle.io/jbcool17/chat_app_channels.svg?label=done&title=Done)](http://waffle.io/jbcool17/chat_app_channels) [![Stories in Backlog](https://badge.waffle.io/jbcool17/chat_app_channels.svg?label=backlog&title=backlog)](http://waffle.io/jbcool17/chat_app_channels)

> Chat Application using multiple websockets

This project is built with Sinatra/Ruby along with sinatra-websockets/faye gems to utilize websockets. Join a channel and start chatting.

## Table of Contents

- [Development](#development)
- [Usage](#usage)
- [Deploy/Hosting](#deployhosting)
- [Specs](#specs)
- [Styles](#styles)
- [License](#license)

## Development

```
# App Setup
$ bundle install

# DB Setup
$ bundle exec rake db:migrate
$ bundle exec rake db:seed
```

## Usage
```
# Startup Server
$ bundle exec rackup
```

## Deploy/Hosting
[![Heroku](https://heroku-badge.herokuapp.com/?app=heroku-badge&style=flat)](https://heroku-badge.herokuapp.com/projects.html)
- Hosted on Heroku
- [Online Here](https://intense-temple-95153.herokuapp.com/)

## Specs
- Sinatra / ruby 2.3.0
- sinatra-websockets / faye
- postgres - production / sqlite3 - development

## Styles
- custom css

## License

MIT © John Brilla
