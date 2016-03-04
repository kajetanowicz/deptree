describe Deptree::DSL do

  let(:host_class) {
    Class.new { extend Deptree::DSL }
  }

  it 'adds DSL for defining dependencies' do
    expect(host_class).to respond_to(:dependency)
  end

  describe 'adding a new dependency' do
    it 'allows to add a new dependency to the Registry' do
      host_class.dependency 'foo'

      expect(host_class.dependencies).to include 'foo'
    end
  end

  describe '.configure' do
    it 'invokes configuration task on each dependency' do
      called = Array.new

      klass = Class.new do
        extend Deptree::DSL

        dependency :foo do
          configure do
            called << :foo
          end
        end

        dependency :bar do
          configure do
            called << :bar
          end
        end
      end

      klass.configure
      expect(called).to eq [:foo, :bar]
    end

    context 'when explicitly passed names' do
      it 'invokes configuration on chosen dependencies' do
        called = Array.new

        klass = Class.new do
          extend Deptree::DSL

          dependency :foo do
            configure do
              called << :foo
            end
          end

          dependency :bar do
            configure do
              called << :bar
            end
          end
        end

        klass.configure(:bar)
        expect(called).to eq [:bar]
      end
    end
  end
end
