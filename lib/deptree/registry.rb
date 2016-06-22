module Deptree
  class Registry

    def initialize
      @dependencies = {}
    end

    def add(name, dependency)
      fail DuplicateDependencyError.new(name) if include?(name)
      @dependencies.store(normalize(name), dependency)
    end

    def find(name)
      @dependencies.fetch(normalize(name))
    end

    def select(*names)
      if names.empty?
        @dependencies.values
      else
        names.map { |name| find(name) }
      end
    end

    def include?(name)
      @dependencies.has_key?(name)
    end

    private

    def normalize(name)
      name.to_s
    end
  end
end
