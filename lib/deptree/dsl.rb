module Deptree
  module DSL

    def dependency(*args, &block)
      Definition.add(dependencies, args, block)
    end

    def configure(*names)
      Resolver.resolve(dependencies.select(*names)).each do |dependency|
        dependency.run_action(:configure)
      end
    end

    def dependencies
      @dependencies ||= Deptree::Registry.new
    end
  end
end
