module Deptree
  class ArgumentsParser

    attr_reader :name

    attr_reader :prerequisites

    def initialize(args)
      @args = args
    end

    def parse!
      fail! if @args.size > 1
      args = @args.first

      case args
      when String, Symbol
        @name, @prerequisites = args, []
      when Hash
        fail! if args.size != 1
        @name, @prerequisites = args.map { |k, v| [k, Array(v)] }.first
      else
        fail!
      end

      return self
    end

    private

    def fail!
      fail InvalidArgumentError.new(@args)
    end
  end
end
