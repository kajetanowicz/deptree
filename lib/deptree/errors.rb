module Deptree
  class Error < StandardError; end


  class InvalidArgumentError < Error
    def initialize(args)
      @args = args
      super(message)
    end

    def message
      "Dependency takes either a String or a Hash with a single key-value pair. Got: #{@args}"
    end
  end

end