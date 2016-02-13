module Deptree
  class DefinitionContext < BasicObject

    def self.define_dependency(*args, &block)
      parser = ArgumentsParser.new(args).parse!

      Dependency.new(parser.name, parser.prerequisites).tap do |dependency|
        context = self.new(dependency)
        context.instance_eval(&block) if block_given?
      end
    end

    def initialize(dependency)
      @dependency = dependency
    end

    def method_missing(name, *args, &behaviour)
      @dependency.add_action(name, args, behaviour)
    end
  end
end
