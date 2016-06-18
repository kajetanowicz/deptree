module Deptree
  module DSL

    def dependency(*args, &block)
      Definition.add(self, args, block)
    end

    def configure(*names)
      Resolver.resolve(dependencies.select(*names)).each do |dependency|
        dependency.run_action(:configure)
      end
    end

    def helpers(&block)
      @helpers ||= Module.new
      @helpers.module_eval(&block) if block_given?
      @helpers
    end

    def dependencies
      @dependencies ||= Deptree::Registry.new
    end
  end
end
