# Cinch::Plugins::LinksTitles

[![Gem Version](https://badge.fury.io/rb/cinch-links-titles.png)](http://badge.fury.io/rb/cinch-links-titles)
[![Dependency Status](https://gemnasium.com/bhaberer/cinch-links-titles.png)](https://gemnasium.com/bhaberer/cinch-links-titles)
[![Build Status](https://travis-ci.org/bhaberer/cinch-links-titles.png?branch=master)](https://travis-ci.org/bhaberer/cinch-links-titles)
[![Coverage Status](https://coveralls.io/repos/bhaberer/cinch-links-titles/badge.png?branch=master)](https://coveralls.io/r/bhaberer/cinch-links-titles?branch=master)
[![Code Climate](https://codeclimate.com/github/bhaberer/cinch-links-titles.png)](https://codeclimate.com/github/bhaberer/cinch-links-titles)

Cinch Plugin for logging links and printing titles / stats for linked urls.

## Installation

Add this line to your application's Gemfile:

    gem 'cinch-links-titles'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cinch-links-titles

## Usage

You will need to add the Plugin and config to your list first;

    @bot = Cinch::Bot.new do
      configure do |c|
        c.plugins.plugins = [Cinch::Plugins::LinksLogger]
        c.plugins.options[Cinch::Plugins::LinksTumblr] = { :stats     => true,
                                                           :filename  => 'yaml/links.yml',
                                                           :whitelist => nil,
                                                           :blacklist => nil }
      end
    end

The configuration variables are all optional, what's listed are their defaults

:stats (boolean) - Setting this to true will print the name of the user who first linked
                   the URL, if applicable.

:blacklist - An array of domains that you want to ignore, e.g.

    :blackist => ['twitter', 'reddit']

:whitelist - An array of domains that you want limit title printing and logging to, e.g.

    :whitelist => ['youtube']

:filename - the file to store previously linked urls.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
