describe Deptree::Registry do
  let(:registry) { Deptree::Registry.new }

  before do
    registry.add('dep1', double('Dependency', name: 'Dependency1'))
    registry.add('dep2', double('Dependency', name: 'Dependency2'))
    registry.add('dep3', double('Dependency', name: 'Dependency3'))
    registry.add('dep4', double('Dependency', name: 'Dependency4'))
  end

  describe '#add' do
    it 'registers a dependency' do
      expect(registry).to_not include('dep_name')

      registry.add('dep_name', double('Dependency1'))
      expect(registry).to include('dep_name')
    end

    it 'prevents from adding the same dependency more than once' do
      expect {
        registry.add('dep_name', double('Dependency1'))
        registry.add('dep_name', double('Dependency1'))

      }.to raise_error(Deptree::DuplicateDependencyError, /dep_name/)
    end
  end

  describe '#find' do
    it 'finds dependency by name' do
      expect(registry.find('dep1').name).to eq 'Dependency1'
    end

    it 'accepts symbolized names' do
      expect(registry.find(:dep2).name).to eq 'Dependency2'
    end

    context 'when trying to find non-existing dependency' do
      it 'raises an exception' do
        expect { registry.find('non-existing') }.
          to raise_error(KeyError, /non-existing/)
      end
    end
  end

  describe '#select' do
    it 'returns selected dependencies' do
      expect(registry.select('dep1', 'dep3').size).to eq 2
    end

    context 'when called without any names' do
      it 'returns all registered dependencies' do
        expect(registry.select.size).to eq 4
      end
    end
  end
end
