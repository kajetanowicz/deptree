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

  it 'makes helpers available in the context of configure block' do
    ARGS = []

    application = Class.new do
      extend Deptree::DSL

      dependency :one do
        configure do
          foo(:one)
        end
      end

      dependency :two do
        configure do
          foo(:two)
        end
      end

      helpers do
        def foo(name)
          ARGS << name
        end
      end
    end

    application.configure
    expect(ARGS.sort).to eq [:one, :two].sort
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

      dependency :three => :two do
        configure { called << :three }
      end
      dependency :two do
        configure { called << :two }
      end
    end

    application.configure
    expect(called.index(:two)).to be < called.index(:three)
  end

  it 'handles 3 ordered dependencies ' do
    called = []
    application = Class.new do
      extend Deptree::DSL

      dependency :three => :two do
        configure { called << :three }
      end
      dependency :four => :three do
        configure { called << :four }
      end
      dependency :two do
        configure { called << :two }
      end
    end

    application.configure
    expect(called.index(:two)).to be < called.index(:three)
    expect(called.index(:three)).to be < called.index(:four)
  end

  it 'handles 6 ordered dependencies ' do
    called = []
    application = Class.new do
      extend Deptree::DSL

      dependency :five => [:six, :four] do
        configure { called << :five }
      end
      dependency :six do
        configure { called << :six }
      end
      dependency :three => :two do
        configure { called << :three }
      end
      dependency :four => :two do
        configure { called << :four }
      end
      dependency :two do
        configure { called << :two }
      end
      dependency :one => :five do
        configure { called << :one }
      end
    end

    application.configure
    expect(called.index(:four)).to be < called.index(:five)
    expect(called.index(:five)).to be < called.index(:one)
    expect(called.index(:two)).to be < called.index(:one)
  end

  it 'detects indirect circular dependencies' do
    application = Class.new do
      extend Deptree::DSL

      dependency :five => :four do
        configure { called << :five }
      end
      dependency :six => [:five] do
        configure { called << :six }
      end
      dependency :three => :two do
        configure { called << :three }
      end
      dependency :four => :three do
        configure { called << :four }
      end
      dependency :two => :one do
        configure { called << :two }
      end
      dependency :one => :five do
        configure { called << :one }
      end
    end

    expect { application.configure }.
      to raise_error(Deptree::CircularDependencyError)
  end

  it 'detects when dependency in linked to itself' do
    application = Class.new do
      extend Deptree::DSL

      dependency :one => :one do
        configure { called << :one }
      end
    end

    expect { application.configure }.
      to raise_error(Deptree::CircularDependencyError)
  end
end
