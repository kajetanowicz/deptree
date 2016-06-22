module Deptree
  class Dependency

    attr_reader :name, :prerequisites, :actions

    def initialize(name, prerequisites, helpers)
      @name = name
      @prerequisites = prerequisites
      @helpers = helpers
      @actions = Actions.new(self)
    end

    def action(name, &behaviour)
      @actions.add(name, behaviour)
    end

    def execute(name)
      if (action = @actions.find(name))
        action.execute
      end
    end

    def execution_context
      @execution_context ||= Object.new.tap do |ctx|
        ctx.extend(@helpers)
      end
    end


    class Actions
      def initialize(dependency)
        @dependency, @actions = dependency, []
      end

      def add(name, behaviour)
        if find(name)
          fail DuplicateActionError.new(@dependency.name, name)
        else
          Action.new(name, behaviour, @dependency.execution_context).tap do |action|
            @actions << action
          end
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
