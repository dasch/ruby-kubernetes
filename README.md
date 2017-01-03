# Kubernetes

A client library for [Kubernetes](http://kubernetes.io/) in Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kubernetes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kubernetes

## Usage

```ruby
require 'kubernetes'

# Assumes you're running a local proxy or SSH tunnel.
client = Kubernetes.new

# Connect to server from within a pod:
token = File.read('/var/run/secrets/kubernetes.io/serviceaccount/token')
client = Kubernetes.new({
  connection: {
    host: 'https://kubernetes', 
    headers: { Authorization: "Bearer #{token}"}, 
    ssl_verify_peer: false }})

# Lists all pods:
client.get_pods

# Lists all replication controllers:
client.get_replication_controllers

# Get the logs for a specific pod:
client.logs("some-pod")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/kubernetes/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
