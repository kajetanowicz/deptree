module Deptree
  class Dependency
    class Actions
      def initialize(dependency)
        @dependency, @actions = dependency, []
      end

      def add(name, behaviour)
        fail DuplicateActionError.new(@dependency.name, name) if find(name)

        action = Action.new(name, behaviour, @dependency.execution_context)
        @actions << action
        action
      end

      def find(name)
        @actions.find { |a| a.name == name }
      end

      def size
        @actions.size
      end
    end

    class Action
      attr_reader :name

      def initialize(name, behaviour, context)
        @name, @behaviour, @context = name, behaviour, context
      end

      def execute
        @context.instance_eval(&@behaviour)
      end

      def ==(other)
        name == other.name
      end
    end
  end
end
