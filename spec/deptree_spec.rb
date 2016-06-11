describe '.configure' do
  it 'handles single dependency' do
    called = []
    application = Class.new do
      extend Deptree::DSL

      dependency :one do
        configure { called << :one }
      end
    end

    application.configure
    expect(called).to eq [:one]
  end

  it 'handles multiple un-linked dependencies' do
    called = []
    application = Class.new do
      extend Deptree::DSL

      dependency :one do
        configure { called << :one }
      end
      dependency :two do
        configure { called << :two }
      end
      dependency :three do
        configure { called << :three }
      end
    end

    application.configure
    expect(called.sort).to eq [:one, :three, :two]
  end

  it 'only resolves specified dependencies' do
    called = []
    application = Class.new do
      extend Deptree::DSL

      dependency :one do
        configure { called << :one }
      end
      dependency :two do
        configure { called << :two }
      end
      dependency :three do
        configure { called << :three }
      end
    end

    application.configure(:three, :two)
    expect(called.sort).to eq [:three, :two]
  end

  it 'invokes indirect dependencies' do
    called = []
    application = Class.new do
      extend Deptree::DSL

      dependency :one => [:two] do
        configure { called << :one }
      end
      dependency :two => :three do
        configure { called << :two }
      end
      dependency :three do
        configure { called << :three }
      end
    end

    application.configure(:one)
    expect(called.sort).to eq [:one, :three, :two]
  end

  it 'detects simple circular dependencies' do
    called = []
    application = Class.new do
      extend Deptree::DSL

      dependency :one =>:two do
        configure { called << :one }
      end
      dependency :two => :one do
        configure { called << :two }
      end
    end

    expect { application.configure }.
      to raise_error(Deptree::CircularDependencyError)
  end

  it 'handles 2 ordered dependencies ' do
    called = []
    application = Class.new do
      extend Deptree::DSL

      dependency :two do
        configure { called << :two }
      end
      dependency :three => :two do
        configure { called << :three }
      end
    end

    application.configure
    expect(called.index(:two)).to be < called.index(:three)
  end
end
