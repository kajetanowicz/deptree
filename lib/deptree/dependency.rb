module Deptree
  class Dependency

    attr_reader :name
    attr_reader :prerequisites

    def initialize(name, prerequisites = [])
      @name = name
      @prerequisites = prerequisites
    end

  end
end
