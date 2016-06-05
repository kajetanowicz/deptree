describe Deptree::Registry do
  let(:registry) { Deptree::Registry.new }

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
    before do
      registry.add('dep1', double('Dependency1'))
      registry.add('dep2', double('Dependency2'))
      registry.add('dep3', double('Dependency3'))
    end

    it 'returns all dependencies specified on the list' do
      expect(registry.find(['dep1', 'dep3']).size).to eq 2
    end

    it 'accepts names as symbols' do
      expect(registry.find([:dep1]).size).to eq 1
    end

    context 'when trying to find non-existing dependency' do
      it 'raises an exception' do
        expect { registry.find(['non-existing']) }.
          to raise_error(KeyError, /non-existing/)
      end
    end

    context 'when passed an empty list' do
      it 'returns an empty list' do
        expect(registry.find([])).to eq []
      end
    end
  end

  describe '#all' do
    before do
      registry.add('dep1', double('Dependency1'))
      registry.add('dep2', double('Dependency2'))
      registry.add('dep3', double('Dependency3'))
      registry.add('dep4', double('Dependency4'))
    end

    it 'returns all registered dependencies' do
      expect(registry.all.size).to eq 4
    end
  end
end
