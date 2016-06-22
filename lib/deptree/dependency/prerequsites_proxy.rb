module Deptree
  class Dependency
    class PrerequisitesProxy
      include Enumerable

      def initialize(names, registry)
        @names, @registry = names, registry
      end

      def each(&block)
        @names.each do |name|
          block.call(@registry.find(name))
        end
      end
    end
  end
end
