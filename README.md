# Easly manage initialization steps in your Ruby application.

When building Ruby applications, quite often, your application has to be properly configured before it can be run. Configuration steps might include things like: reading config files, instantiating singleton objects (`Logger` for example), configuring various API  clients, establishing connections to databases, message brokers etc. It can become a tedious task if your application is complex and some steps depend on another.

**Deptree** is attempting to solve this problem by exposing declarative DSL that allows to define configuration steps, dependencies between them and most importantly, executing those steps without explicitly specifying the order of invocation.

## Usage

First, you need to define all the configuration steps (with their dependencies) required by your application:

```ruby
module Application
  module Dependencies
    extend Deptree::DSL

    dependency :config_file do
      configure do
        Application.config = YAML.load_file('config.yml')[environment]
      end
    end

    dependency :logger => :config_file do
      configure do
        Application.logger = Logger.new(Application.config.log_path)
      end
    end

    dependency :github_client => [:logger, :config_file] do
      configure do
        GithubClient.configure do |config|
          config.host = Application.config.github.host
          config.logger = Application.logger
        end
      end
    end

    helpers do
      def environment
        ENV['RACK_ENV'] || 'development'
      end
    end
  end
end
```

Once you're ready to start your app, invoke all the configuration steps:

```ruby
#!/usr/bin/env ruby

require 'application'

Application::Dependencies.configure
# At this point **ALL** the configuration steps required by your application
# will have run in correct order

# Start your application
Application.run!

```

Alternatively, you can choose to invoke only specific steps:

```ruby
Application::Dependencies.configure(:logger, :github_client)
# NOTE: config will be automatically loaded since both (logger and github_cllient) depend on it.
```

## How it works
Each configuration step can be represented as a vertex in a [directed graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) where each dependency between two steps forms an edge. In order to invoke those steps in correct order, we first need to sort those vertices in a [topological order](https://en.wikipedia.org/wiki/Topological_sorting). **Deptree** gem uses a simplified version of *Kahn's* alghoritm to achieve this.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deptree'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deptree

## Code status

[![Build Status](https://travis-ci.org/kajetanowicz/deptree.svg?branch=master)](https://travis-ci.org/kajetanowicz/deptree)

## Contributing

1. Fork it ( https://github.com/kajetanowicz/deptree/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
