module Deptree
  module DSL

    def dependency(*args, &block)
      Definition.add(self, args, block)
    end

    def configure(*names)
      Visitor.each(registry.select(*names)) do |dependency|
        dependency.execute(:configure)
      end
    end

    def helpers(&block)
      @helpers ||= Module.new
      @helpers.module_eval(&block) if block_given?
      @helpers
    end

    def registry
      @registry ||= Deptree::Registry.new
    end
  end
end
