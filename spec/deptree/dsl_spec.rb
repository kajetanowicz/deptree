describe Deptree::DSL do

  let(:host_class) {
    Class.new { extend Deptree::DSL }
  }

  it 'defines DSL for adding dependencies' do
    expect(host_class).to respond_to(:dependency)
  end

  it 'defines DSL for configuring dependencies' do
    expect(host_class).to respond_to(:configure)
  end

  it 'defines DSL for adding helpers' do
    expect(host_class).to respond_to(:helpers)
  end

  describe 'adding a new dependency' do
    it 'allows to add a new dependency to the Registry' do
      host_class.dependency 'foo' do; end

      expect(host_class.registry).to include 'foo'
    end
  end

  describe '.helpers' do
    context 'when called without block' do
      it 'returns a module with helper methods' do
        expect(host_class.helpers).to be_a(Module)
      end

      it 'returns the same module when called multiple times' do
        expect(host_class.helpers).to eq host_class.helpers
      end
    end

    context 'when called with block' do
      it 'defines methods in an anonymous module' do
        host_class.helpers do
          def foo
            # ...
          end

          def bar
            # ...
          end
        end

        host_class.helpers do
          def baz;
            # ...
          end
        end

        object = Object.new
        object.extend(host_class.helpers)

        expect(object).to respond_to(:foo)
        expect(object).to respond_to(:bar)
        expect(object).to respond_to(:baz)
      end
    end
  end
end
