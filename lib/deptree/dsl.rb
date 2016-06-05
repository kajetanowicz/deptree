module Deptree
  module DSL

    def dependency(*args, &block)
      DefinitionContext.define_dependency(*args, &block).tap do |dependency|
        dependencies.add(dependency.name, dependency)
      end
    end

    def configure(*names)
      runnable = names.empty? ? dependencies.all : dependencies.find(names)

      runnable.map do |dependency|
        dependency.run_action(:configure)
      end
    end

    def dependencies
      @dependencies ||= Deptree::Registry.new
    end
  end
end
