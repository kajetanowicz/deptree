module Deptree
  module DSL

    def dependency(*args, &block)
      Definition.add(dependencies, args, block)
    end

    def configure(*names)
      runnables = if names.empty?
        dependencies.all
      else
        names.map { |name| dependencies.find(name) }
      end

      Resolver.resolve(runnables).each do |dependency|
        dependency.run_action(:configure)
      end
    end

    def dependencies
      @dependencies ||= Deptree::Registry.new
    end
  end
end
