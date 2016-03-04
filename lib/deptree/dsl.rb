module Deptree
  module DSL

    def dependency(*args, &block)
      DefinitionContext.define_dependency(*args, &block).tap do |dependency|
        dependencies.add(dependency.name, dependency)
      end
    end

    def configure(*names)
      dependencies.find(names).map { |dep| dep.run_action(:configure) }
    end

    def dependencies
      @dependencies ||= Deptree::Registry.new
    end
  end
end
