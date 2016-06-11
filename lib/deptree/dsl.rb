module Deptree
  module DSL

    def dependency(*args, &block)
      DefinitionContext.define_dependency(*args, &block).tap do |dependency|
        dependencies.add(dependency.name, dependency)
      end
    end

    def configure(*names)
      if names.empty?
        runnables = dependencies.all
      else
        runnables = names.map { |name| dependencies.find(name) }
      end

      Resolver.resolve(runnables).map do |dependency|
        dependency.run_action(:configure)
      end
    end

    def dependencies
      @dependencies ||= Deptree::Registry.new
    end
  end
end
