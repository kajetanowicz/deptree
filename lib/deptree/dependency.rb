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
  end
end
