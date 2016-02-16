module Deptree
  class Dependency

    attr_reader :name
    attr_reader :prerequisites
    attr_reader :actions

    def initialize(name, prerequisites = [])
      @name = name
      @actions = []
      @prerequisites = prerequisites
      @execution_context = Object.new
    end

    def add_action(name, *args, &behaviour)
      Action.new(name, args, behaviour).tap do |action|
        if actions.member?(action)
          fail DuplicateActionError.new(@name, action.name)
        else
          actions << action
        end
      end
    end

    def run_action(name)
      if ( action = find(name) )
        action.run(@execution_context)
      end
    end

    def find(name)
      actions.find { |a| a.name == name }
    end

    class Action
      attr_reader :name

      def initialize(name, args, behaviour)
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
