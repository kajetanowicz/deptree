module Deptree
  describe Definition do
    describe '.add' do
      let(:registry) { Registry.new }

      it 'returns a dependency' do
        expect(Definition.add(registry, ['foo'], Proc.new {})).to  be_a(Dependency)
      end

      it 'yields a block within an instance of DefinitionContext' do
        expect { |b| Definition.add(registry, ['bar'], b) }.to yield_control.once
      end

      it 'allows to define various actions' do
        block = Proc.new do
          action_one do; end
          action_two do; end
          action_three do; end
        end
        dependency = Definition.add(registry, ['baz'], block)

        expect(dependency.actions.size).to eq 3
      end
    end
  end
end
