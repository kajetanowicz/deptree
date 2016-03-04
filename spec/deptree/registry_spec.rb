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
    before {
      registry.add('name1', double('Dependency1'))
      registry.add('name2', double('Dependency2'))
    }

    context 'when passed an empty list' do
      it 'returns all dependencies' do
        expect(registry.find([]).size).to eq 2
      end
    end

    context 'when passed a list that contains names' do
      it 'returns all dependencies' do
        expect(registry.find([:name1]).size).to eq 1
      end
    end
  end
end

