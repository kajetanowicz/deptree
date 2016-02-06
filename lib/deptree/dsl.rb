module Deptree
  module DSL

    def dependency(name_and_prerequisites, &block)
      dependency = DefinitionContext.define_dependency(name_and_prerequisites, &block)
      dependencies.add(dependency.name, dependency)
    end

    def dependencies
      @dependencies ||= Deptree::Registry.new
    end
  end
end
