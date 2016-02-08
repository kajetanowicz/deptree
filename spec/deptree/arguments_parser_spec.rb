module Deptree
  describe ArgumentsParser do

      def parse(*args)
        ArgumentsParser.new(args).parse!
      end

      it 'retrieves correct dependency name' do
        parser = parse('bar')

        expect(parser.name).to eq('bar')
        expect(parser.prerequisites).to eq([])
      end

      context 'when the dependency has one prerequisite' do
        it 'retrieves correct name and prerequisites' do
          parser = parse('foo' => 'bar')

          expect(parser.name).to eq('foo')
          expect(parser.prerequisites).to eq(['bar'])
        end
      end

      context 'when the dependency has many prerequisites' do
        it 'retrieves correct name and prerequisites' do
          parser = parse('foo' => ['bar', 'baz'])

          expect(parser.name).to eq('foo')
          expect(parser.prerequisites).to eq(['bar', 'baz'])
        end
      end

      context 'when the dependency name is a Symbol' do
        it 'retrieves correct name and prerequisites' do
          parser = parse(:foo => ['bar', 'baz'])

          expect(parser.name).to eq(:foo)
          expect(parser.prerequisites).to eq(['bar', 'baz'])
        end
      end

      context 'when passing invalid arguments' do
        it 'raises an exception' do
          expect { parse('foo' => 'bar', 'bar' => 'baz') }.
            to raise_error(InvalidArgumentError, /Got: {"foo"=>"bar", "bar"=>"baz"}/)
        end
      end
  end
end
