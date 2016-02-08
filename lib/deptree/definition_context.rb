module Deptree
  class DefinitionContext < BasicObject

    def self.define_dependency(*args, &block)
      name, prerequisites = retrieve_from_args(*args)
      Dependency.new(name, prerequisites)
    end

    def self.retrieve_from_args(*args)
      fail InvalidArgumentError.new(args) if args.size > 1
      args = args.shift

      case args
      when ::String, ::Symbol
        name, prerequisites = args, []
      when ::Hash
        fail InvalidArgumentError.new(args) if args.size != 1
        name, prerequisites = args.map { |k, v| [k, Array(v)] }.first
      else
        fail InvalidArgumentError.new(args)
      end

      return name, prerequisites
    end
  end
end
