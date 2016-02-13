module Deptree
  describe DefinitionContext do
    describe '.define_dependency' do

      it 'returns a dependency' do
        expect(DefinitionContext.define_dependency('foo')).to  be_a(Dependency)
      end

      it 'yields a block within an instance of DefinitionContext' do
        expect { |b| DefinitionContext.define_dependency('bar', &b) }.to yield_control.once
      end

      it 'allows to define various actions' do
        dependency = DefinitionContext.define_dependency('baz') do
          action_one do; end
          action_two do; end
          action_three do; end
        end

        expect(dependency.actions.size).to eq 3
      end
    end
  end
end
