module Deptree
  class Registry

    def initialize
      @dependencies = {}
    end

    def add(name, dependency)
      fail DuplicateDependencyError.new(name) if include?(name)

      @dependencies.store(name, dependency)
    end

    def include?(name)
      @dependencies.has_key?(name)
    end

  end
end
