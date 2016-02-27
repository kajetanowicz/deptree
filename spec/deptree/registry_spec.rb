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
end

