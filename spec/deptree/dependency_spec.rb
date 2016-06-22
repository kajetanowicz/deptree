module Deptree
  describe Dependency do
    subject(:dependency) { Dependency.new('foo', [], Module.new) }

    describe '#action' do
      it 'returns an Action' do
        action = dependency.action(:configure) do; end

        expect(action).to be_an(Dependency::Action)
        expect(action.name).to eq :configure
      end

      it 'does not allow to define an action with the same name twice' do
        expect {
          dependency.action(:configure) do; end
          dependency.action(:configure) do; end
        }.to raise_error(DuplicateActionError, /foo.*configure/)
      end
    end

    describe '#execute' do
      it 'executes an action' do
        expect { |blk|
          dependency.action(:foo, &blk)
          dependency.execute(:foo)

        }.to yield_control.once
      end

      it 'executes all actions in the same context' do
        ctx = self
        ctx1 = ctx2 = nil

        dependency.action(:action1) { ctx1 = self }
        dependency.action(:action2) { ctx2 = self }

        dependency.execute(:action1)
        dependency.execute(:action2)

        expect(ctx1).to eql(ctx2)
        expect(ctx).not_to eql(ctx1)
        expect(ctx).not_to eql(ctx2)
      end
    end
  end
end
