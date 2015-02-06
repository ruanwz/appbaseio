# Appbaseio

[![Build
Status](https://travis-ci.org/ruanwz/appbaseio.svg)](https://travis-ci.org/ruanwz/appbaseio)

AppBase.io Ruby Rest Client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'appbaseio'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install appbaseio

## Usage

Read /spec/appbaseio/client\_spec.rb

```
require 'Appbaseio'
options = {
  server_host:  'api.appbase.io',
  app_name: 'testapp',
  api_version: 'v2',
  namespace: 'test_api',
  app_secret: 'your secret'
}
client = Appbaseio::Client.new(options)
client.create_properties vertex: 'abc', data: {foo: 'bar'}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/appbaseio/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
