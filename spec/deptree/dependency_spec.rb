module Deptree
  describe Dependency do

    subject(:dependency) { Dependency.new('foo', []) }

    describe '#add_action' do
      it 'returns an Action' do
        action = dependency.add_action(:configure, :arg1, :arg2) do; end

        expect(action).to be_an(Dependency::Action)
        expect(action.name).to eq :configure
      end

      it 'does not allow to define an action with the same name twice' do
        expect {
          dependency.add_action(:configure)
          dependency.add_action(:configure)
        }.to raise_error(DuplicateActionError, /foo.*configure/)
      end
    end
  end
end
