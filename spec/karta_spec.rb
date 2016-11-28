require 'spec_helper'

describe Karta do

  describe '.mapper_registry' do

    context 'when a mapper registry has already been initialized' do
      let(:mapper_registry) { double('mapper_registry') }

      it 'returns the mapper registry' do
        Karta.instance_variable_set('@mapper_registry', mapper_registry)
        expect(Karta.mapper_registry).to eq mapper_registry
      end
    end

    context 'when no mapper registry has been initialized' do
      it 'initializes the mapper registry to an empty array' do
        expect(Karta.instance_variable_get('@mapper_registry')).to be_nil
        Karta.mapper_registry
        expect(Karta.instance_variable_get('@mapper_registry')).to be_a Karta::MapperRegistry
      end
    end
  end

  describe '.register_mapper' do
    let(:mapper_registry) { double('mapper_registry') }
    let(:mapper)          { double('mapper') }
    let(:from_klass)      { double('from_klass') }
    let(:to_klass)        { double('to_klass') }

    before do
      expect(Karta).to receive(:mapper_registry).and_return(mapper_registry)
    end

    it 'registers a mapper' do
      expect(mapper_registry).to receive(:register)\
        .with(mapper: mapper, from_klass: from_klass, to_klass: to_klass)

      Karta.register_mapper(mapper, from_klass: from_klass, to_klass: to_klass)
    end
  end

  describe '.map' do

    context 'when trying to map from a class' do
      let(:foo) { double('foo') }

      before do
        define_klass(name: 'Bar')
      end

      it 'raises an ArgumentError' do
        expect{
          Karta.map(from: Bar, to: foo)
        }.to raise_error(ArgumentError, "cannot map from a class")
      end
    end

    context 'when mapping to a class' do
      let(:mapper)          { double('mapper') }
      let(:mapper_registry) { double('mapper_registry') }
      let(:bar)             { double('bar') }

      before do
        define_klass(name: 'Foo')
        allow(Karta).to receive(:mapper_registry).and_return(mapper_registry)
      end

      it 'finds a a mapper and maps' do
        expect(mapper_registry).to receive(:find).and_return(mapper)
        expect(mapper).to receive(:map).with(from: bar, to: Foo)

        Karta.map(from: bar, to: Foo)
      end
    end

    context 'when mapping to an instance' do
      let(:mapper)          { double('mapper') }
      let(:mapper_registry) { double('mapper_registry') }
      let(:bar)             { double('bar') }
      let(:foo)             { double('foo') }

      before do
        allow(Karta).to receive(:mapper_registry).and_return(mapper_registry)
      end

      it 'performs the mapping and returns the mapped instance' do
        expect(mapper_registry).to receive(:find).and_return(mapper)
        expect(mapper).to receive(:map).with(from: bar, to: foo)

        Karta.map(from: bar, to: foo)
      end
    end
  end
end
