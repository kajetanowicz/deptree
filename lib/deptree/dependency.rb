module Deptree
  class Dependency

    attr_reader :name
    attr_reader :prerequisites
    attr_reader :actions

    def initialize(name, prerequisites = [])
      @name = name
      @actions = []
      @prerequisites = prerequisites
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

    class Action
      attr_reader :name

      def initialize(name, args, behaviour)
        @name = name
        @behaviour = behaviour
        @options = args.last.is_a?(Hash) ? args.pop : {}
        @args = args
      end

      def ==(other)
        name == other.name
      end

    end

  end
end
