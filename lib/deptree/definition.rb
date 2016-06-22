module Deptree
  class Definition < BasicObject

    def self.add(configurable, args, block)
      parser = ArgumentsParser.new(args).parse!
      prerequisites = Dependency::PrerequisitesProxy.new(parser.prerequisites, configurable.registry)
      name = parser.name

      Dependency.new(name, prerequisites, configurable.helpers).tap do |dependency|
        self.new(dependency).instance_eval(&block)
        configurable.registry.add(dependency.name, dependency)
      end
    end

    def initialize(dependency)
      @dependency = dependency
    end

    def method_missing(name, &behaviour)
      @dependency.action(name, &behaviour)
    end
  end

end
