module Deptree
  describe DefinitionContext do
    describe '.define_dependency' do

      it 'returns a dependency' do
        expect(DefinitionContext.define_dependency('foo')).to  be_a(Dependency)
      end

      it 'sets correct dependency name' do
        dependency = DefinitionContext.define_dependency('bar')

        expect(dependency.name).to eq('bar')
        expect(dependency.prerequisites).to eq([])
      end

      context 'when the dependency has one prerequisite' do
        it 'sets correct name and prerequisites' do
          dependency = DefinitionContext.define_dependency('foo' => 'bar')

          expect(dependency.name).to eq('foo')
          expect(dependency.prerequisites).to eq(['bar'])
        end
      end

      context 'when the dependency has many prerequisites' do
        it 'sets correct name and prerequisites' do
          dependency = DefinitionContext.define_dependency('foo' => ['bar', 'baz'])

          expect(dependency.name).to eq('foo')
          expect(dependency.prerequisites).to eq(['bar', 'baz'])
        end
      end

      context 'when the dependency name is a Symbol' do
        it 'sets correct name and prerequisites' do
          dependency = DefinitionContext.define_dependency(:foo => ['bar', 'baz'])

          expect(dependency.name).to eq(:foo)
          expect(dependency.prerequisites).to eq(['bar', 'baz'])
        end
      end

      context 'when passing invalid arguments' do
        it 'raises an exception' do
          expect { DefinitionContext.define_dependency('foo' => 'bar', 'bar' => 'baz') }.
            to raise_error(InvalidArgumentError, /Got: {"foo"=>"bar", "bar"=>"baz"}/)
        end
      end
    end
  end
end
