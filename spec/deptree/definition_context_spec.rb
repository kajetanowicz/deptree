module Deptree
  describe DefinitionContext do
    describe '.define_dependency' do

      it 'returns a dependency' do
        expect(DefinitionContext.define_dependency('foo')).to  be_a(Dependency)
      end

    end
  end
end
