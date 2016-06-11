module Deptree
  class Resolver
    def self.resolve(runnables)
      new(runnables).sort
    end

    def initialize(runnables)
      @runnables = runnables
    end

    def sort
      closure = compute_closure
      incoming = compute_incoming_edges(closure)

      if incoming.values.none?(&:zero?)
        fail CircularDependencyError
      end

      sorted = []
      queue = incoming.keys.select { |node| incoming[node] == 0 }

      while (node = queue.shift) do
        sorted << node

        node.prerequisites.each do |child|
          incoming[child] -= 1
          queue.push(child) if incoming[child].zero?
        end
      end

      unless incoming.values.all?(&:zero?)
        fail CircularDependencyError
      end

      sorted.reverse
    end

    private

    def compute_closure
      queue = @runnables.dup
      closure = []

      while (node = queue.shift) do
        unless closure.include?(node)
          closure << node
          node.prerequisites.each { |child| queue.push(child) }
        end
      end

      closure
    end

    def compute_incoming_edges(closure)
      incoming = {}
      closure.each { |node| incoming[node] = 0 }

      closure.each do |node|
        node.prerequisites.each do |child|
          incoming[child] += 1
        end
      end

      incoming
    end
  end
end
