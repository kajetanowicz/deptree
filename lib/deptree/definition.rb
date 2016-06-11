module Deptree
  class Definition < BasicObject

    def self.add(registry, args, block)
      parser = ArgumentsParser.new(args).parse!

      Dependency.new(parser.name, parser.prerequisites, registry).tap do |dependency|
        self.new(dependency).instance_eval(&block)
        registry.add(dependency.name, dependency)
      end
    end

    def initialize(dependency)
      @dependency = dependency
    end

    def method_missing(name, &behaviour)
      @dependency.add_action(name, &behaviour)
    end
  end
end
