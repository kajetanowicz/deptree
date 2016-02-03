module Deptree
  module DSL

    def self.extended(host)
      host.instance_eval do
        @registry = Deptree::Registry.new
      end
    end

    def dependency(*args)

    end

    def dependencies
      @registry
    end
  end
end
