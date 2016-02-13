module Deptree
  class Dependency

    attr_reader :name
    attr_reader :prerequisites
    attr_reader :actions

    def initialize(name, prerequisites = [])
      @name = name
      @prerequisites = prerequisites
      @actions = Set.new
    end

    def add_action(name, *args, &behaviour)
      action = Action.new(name, args, behaviour)

      if actions.member?(action)
        fail DuplicateActionError.new(@name, action.name)
      else
        actions << action
      end

      action
    end

    class Action
      attr_reader :name

      def initialize(name, args, behaviour)
        @name = name
        @behaviour = behaviour
        @options = args.last.is_a?(Hash) ? args.pop : {}
        @args = args
      end

      def eql?(other)
        name == other.name
      end

      def hash
        name.hash
      end
    end

  end
end
