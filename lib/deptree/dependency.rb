module Deptree
  class Dependency

    attr_reader :name
    attr_reader :prerequisites
    attr_reader :actions

    def initialize(name, prerequisites = [])
      @name = name
      @prerequisites = prerequisites
      @actions = Actions.new(self)
      @execution_context = Object.new
    end

    def add_action(name, *args, &behaviour)
      @actions.add(name, args, &behaviour)
    end

    def run_action(name)
      if ( action = @actions.find(name) )
        action.run(@execution_context)
      end
    end

    class Actions

      def initialize(dependency)
        @dependency, @actions = dependency, []
      end

      def add(name, args, &behaviour)
        if find(name)
          fail DuplicateActionError.new(@dependency.name, name)
        else
          Action.new(name, args, &behaviour).tap { |action| @actions << action }
        end
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

      def initialize(name, args, &behaviour)
        @name = name
        @behaviour = behaviour
        @options = args.last.is_a?(Hash) ? args.pop : {}
        @args = args
      end

      def run(ctx)
        ctx.instance_eval(&@behaviour)
      end

      def ==(other)
        name == other.name
      end

    end

  end
end
