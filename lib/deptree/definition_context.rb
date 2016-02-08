module Deptree
  class DefinitionContext < BasicObject

    def self.define_dependency(*args, &block)
      parser = ArgumentsParser.new(args).parse!
      Dependency.new(parser.name, parser.prerequisites)
    end
  end
end
