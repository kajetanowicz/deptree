module Deptree
  class Dependency

    attr_reader :name, :prerequisites, :actions

    def initialize(name, prerequisites, registry)
      @name = name
      @prerequisites = PrerequisitesProxy.new(prerequisites, registry)
      @actions = Actions.new(self)
      @execution_context = Object.new
    end

    def add_action(name, &behaviour)
      @actions.add(name, behaviour, @execution_context)
    end

    def run_action(name)
      if (action = @actions.find(name))
        action.run
      end
    end

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

    class Actions

      def initialize(dependency)
        @dependency, @actions = dependency, []
      end

      def add(name, behaviour, execution_context)
        if find(name)
          fail DuplicateActionError.new(@dependency.name, name)
        else
          Action.new(name, behaviour, execution_context).tap { |action| @actions << action }
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
        @name = name
        @behaviour = behaviour
        @context = context
      end

      def run
        @context.instance_eval(&@behaviour)
      end

      def ==(other)
        name == other.name
      end
    end
  end
end
