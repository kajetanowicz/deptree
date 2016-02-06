module Deptree
  class DefinitionContext < BasicObject

    def self.define_dependency(args, &block)
      name, prerequisites = retrieve_from_args(args)
      Dependency.new(name, prerequisites)
    end

    def self.retrieve_from_args(args)
      if args.is_a?(::String)
        return args, []
      elsif args.is_a?(::Hash)
        fail InvalidArgumentError.new(args) if args.size != 1
        return args.map { |k, v| [k, Array(v)] }.first
      else
        fail InvalidArgumentError.new(args)
      end
    end
  end
end
