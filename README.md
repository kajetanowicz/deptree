# Deptree

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

1. Define all the configuration dependencies required by your application:

```ruby
module Application
  extend Deptree::DSL

  dependency :config do
    configure do
      Application.config = # ... load configuration
    end
  end

  dependency :logger => :config do
    configure do
      Application.logger = Logger.new(Application.config.log_path)
    end
  end

  dependency :webservices => [:webservice1, :webservice2]

  dependency :webservice1 => [:logger, :config] do
    configure do
      WebService1::Client.logger = Application.logger
      WebService1::Client.host = Application.config.webservice1_host
    end
  end

  dependency :webservice2 => [:config] do
    configure do
      WebService2::Client.host = Application.config.webservice2_host
    end
  end
end
```

2. Trigger dependency resolution when the application starts:

```ruby

#!/usr/bin/env ruby

require 'application'

Application.configure
Application.run!

```

Alternatively, you can choose to configure only specific dependencies:

```ruby

Application.configure(:logger, :webservice2)
# NOTE: config will be automatically loaded since both (logger and webservice2) depend on it.

```



## Contributing

1. Fork it ( https://github.com/kajetanowicz/deptree/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
