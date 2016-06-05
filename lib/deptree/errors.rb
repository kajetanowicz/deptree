module Deptree
  class Error < StandardError; end

  class InvalidArgumentError < Error
    def initialize(arguments)
      args = arguments.map(&:to_s).join(', ')
      super("Dependency takes either a String or a Hash with a single key-value pair. Got: #{args}")
    end
  end

  class DuplicateActionError < Error
    def initialize(dependency, action)
      super("Dependency #{dependency} already contains the definition of action #{action}")
    end
  end

  class DuplicateDependencyError < Error
    def initialize(name)
      super("Dependency #{name} has already been added.")
    end
  end
end
