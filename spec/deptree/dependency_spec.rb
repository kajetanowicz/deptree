module Deptree
  describe Dependency do

    subject(:dependency) { Dependency.new('foo', [], Registry.new) }

    describe '#prerequisites' do
      it 'returns prerequisites proxy' do
        expect(dependency.prerequisites).to be_a(Dependency::PrerequisitesProxy)
      end
    end

    describe '#add_action' do
      it 'returns an Action' do
        action = dependency.add_action(:configure) do; end

        expect(action).to be_an(Dependency::Action)
        expect(action.name).to eq :configure
      end

      it 'does not allow to define an action with the same name twice' do
        expect {
          dependency.add_action(:configure) do; end
          dependency.add_action(:configure) do; end
        }.to raise_error(DuplicateActionError, /foo.*configure/)
      end
    end

    describe '#run_action' do
      it 'executes an action' do
        expect { |blk|
          dependency.add_action(:foo, &blk)
          dependency.run_action(:foo)

        }.to yield_control.once
      end

      it 'runs different actions in the same context' do
        ctx = self
        ctx1 = ctx2 = nil

        dependency.add_action(:action1) { ctx1 = self }
        dependency.add_action(:action2) { ctx2 = self }

        dependency.run_action(:action1)
        dependency.run_action(:action2)

        expect(ctx1).to eql(ctx2)
        expect(ctx).not_to eql(ctx1)
        expect(ctx).not_to eql(ctx2)
      end
    end
  end
end
