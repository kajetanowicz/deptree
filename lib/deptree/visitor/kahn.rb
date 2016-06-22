module Deptree
  class Visitor
    class Kahn
      def initialize(nodes)
        @nodes = nodes
      end

      def topsort
        sorted = []
        queue = incoming.keys.select { |node| incoming[node].zero? }

        fail CircularDependencyError if queue.empty?

        while (node = queue.shift) do
          sorted << node
          node.prerequisites.each do |child|
            incoming[child] -= 1
            queue.push(child) if incoming[child].zero?
          end
        end

        fail CircularDependencyError unless incoming.values.all?(&:zero?)

        sorted.reverse
      end

      def incoming
        @incoming||= compute_incoming_edges(@nodes)
      end

      def compute_incoming_edges(nodes)
        incoming = {}
        nodes.each { |node| incoming[node] = 0 }

        nodes.each do |node|
          node.prerequisites.each do |child|
            incoming[child] += 1
          end
        end

        incoming
      end
    end
  end
end
