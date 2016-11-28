require 'spec_helper'

describe Karta::MapperRegistry do

  describe '#register' do
    subject(:mapper_registry) { Karta::MapperRegistry.new }

    context 'when from_klass or to_klass are not specified' do
      context 'when the class name of the mapper follows the correct format' do

        before do
          define_klass(name: 'Foo')
          define_klass(name: 'Bar')
          define_mapper(name: 'FooToBarMapper')
        end

        it 'parses the class names from the name of the mapper adds the mapper' do
          mapper_registry.register(mapper: FooToBarMapper)

          expect(mapper_registry.mappers.count).to            eq 1
          expect(mapper_registry.mappers.first[:mapper]).to     eq FooToBarMapper
          expect(mapper_registry.mappers.first[:from_klass]).to eq Foo
          expect(mapper_registry.mappers.first[:to_klass]).to   eq Bar
        end
      end

      context 'when the class name of the mapper does not follow the correct format' do
        before do
          define_mapper(name: 'CustomMapper')
        end

        it 'raises an error' do
          expect{
            mapper_registry.register(mapper: CustomMapper)
          }.to raise_error(Karta::InvalidNameError, 'mapper name must be on format [Foo]To[Bar]Mapper')
        end
      end
    end

    context 'when from_klass and to_klass are specified' do
      before do
        define_klass(name: 'Foo')
        define_klass(name: 'Bar')
        define_mapper(name: 'CustomMapper')
      end

      it 'adds the mapper to the registry' do
        mapper_registry.register(mapper: CustomMapper, from_klass: Foo, to_klass: Bar)

        expect(mapper_registry.mappers.count).to              eq 1
        expect(mapper_registry.mappers.first[:mapper]).to     eq CustomMapper
        expect(mapper_registry.mappers.first[:from_klass]).to eq Foo
        expect(mapper_registry.mappers.first[:to_klass]).to   eq Bar
      end
    end
  end

  describe '#find' do
    subject(:mapper_registry) { Karta::MapperRegistry.new }

    context 'when an appropriate mapper exists' do

      before do
        define_klass(name: 'Foo')
        define_klass(name: 'Bar')
        define_mapper(name: 'FooToBarMapper')

        allow(mapper_registry).to\
          receive(:mappers).and_return([{
            mapper: FooToBarMapper,
            from_klass: Foo,
            to_klass: Bar
          }])
      end


      it 'returns the mapper from the registry' do
        expect(mapper_registry.find(from_klass: Foo, to_klass: Bar)).to eq FooToBarMapper
      end
    end

    context 'when no appropriate mapper can be found' do
      it 'raises an error with a good error message' do
        expect{
          mapper_registry.find(from_klass: Integer, to_klass: Array)
        }.to raise_error(Karta::MapperNotFoundError, 'no mapper found (Integer → Array)')
      end
    end
  end
end
