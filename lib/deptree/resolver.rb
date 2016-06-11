module Deptree
  class Resolver
    def self.resolve(dependencies, registry)

      queue = dependencies.dup
      closure = []

      while !queue.empty? do
        d = queue.shift
        unless closure.include?(d)
          closure << d
          prerequisites = d.prerequisites.map {|p| registry.find(p)}
          prerequisites.map { |p| queue.push(p) }
        end
      end


      incoming = {}
      closure.each { |d| incoming[d.name] = 0 }

      closure.each do |d|
        d.prerequisites.each do |p|
          incoming[p] += 1
        end
      end

      if incoming.values.none?(&:zero?)
        fail CircularDependencyError
      end

      sorted = []
      queue = incoming.keys.select { |name| incoming[name] == 0 }

      while !queue.empty? do
        d = registry.find(queue.shift)
        sorted << d
        d.prerequisites.each do |p|
          incoming[p] -= 1
          if incoming[p] == 0
            queue.push(p)
          end
        end
      end

      unless incoming.values.all?(&:zero?)
        fail CircularDependencyError
      end

      sorted.reverse
    end
  end
end
