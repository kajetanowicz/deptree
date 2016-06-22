require 'set'

module Deptree
  class Visitor
    def self.each(roots, &block)
      new(roots).visit(&block)
    end

    def initialize(roots)
      @roots = roots
    end

    def visit(&block)
      sorted.each(&block)
    end

    private

    def sorted
      Kahn.new(nodes).topsort
    end

    def nodes
      queue = @roots.dup
      nodes = Set.new

      while (node = queue.shift) do
        unless nodes.include?(node)
          nodes.add(node)
          node.prerequisites.each { |child| queue.push(child) }
        end
      end

      nodes
    end
  end
end
