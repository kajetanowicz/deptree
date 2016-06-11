
NOTE: This is still work in progress. If you wish to contribute to this project, take a look at the [Contributing](#contributing) section below.

# Deptree 
[![Build Status](https://travis-ci.org/kajetanowicz/deptree.svg?branch=master)](https://travis-ci.org/kajetanowicz/deptree)

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deptree'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deptree

## Usage

##### Define all the configuration dependencies required by your application:

```ruby
module Application
  extend Deptree::DSL

  dependency :config do
    configure do
      Application.config = YAML.load_file('config.yml')[environment]
    end
  end

  dependency :logger => :config do
    configure do
      Application.logger = Logger.new(Application.config.log_path)
    end
  end

  dependency :some_api => [:logger, :config] do
    configure do
      SomeAPI::Client.logger = Application.logger
      SomeAPI::Client.host = Application.config.some_api_host
    end
  end
  
  helpers do
    def environment
      ENV['RACK_ENV'] || 'development'
    end
  end
end
```

##### Trigger dependency resolution when the application starts:

```ruby

#!/usr/bin/env ruby

require 'application'

Application.configure
# At this point all the configuration steps required by your application
# will have run in correct order

# Start your application
Application.run!

```

Alternatively, you can choose to configure only specific dependencies:

```ruby

Application.configure(:logger, :some_api)
# NOTE: config will be automatically loaded since both (logger and some_api) depend on it.

```



## Contributing

1. Fork it ( https://github.com/kajetanowicz/deptree/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
