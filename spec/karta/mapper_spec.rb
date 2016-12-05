# frozen_string_literal: true
require 'spec_helper'

describe Karta::Mapper do

  describe '#map' do
    before do
      define_klass 'Foo'
      define_klass 'Bar'
    end

    let!(:mapper) do
      define_klass('MyMapper', base: Karta::Mapper).new
    end

    before do
      allow(MyMapper).to receive(:mapping_methods).and_return([:method])
    end

    context 'when to is an instance' do
      let(:from) { Foo.new }
      let(:to)   { Bar.new }

      it 'calls all mapping methods with from and to' do
        expect(mapper).to receive(:send).with(:method, from, to)
        mapper.map(from: from, to: to)
      end
    end

    context 'when to is a class' do
      let(:from) { Foo.new }
      let(:to)   { Bar }

      it 'calls all mapping methods with from and a to instance' do
        expect(mapper).to receive(:send).with(:method, from, to)

        mapper.map(from: from, to: to)
      end
    end
  end

  describe '#mapping_methods' do
    let(:mapper_klass) do
      define_klass 'MyMapper', base: Karta::Mapper do
        def map_foo; end
        def bar; end
        private
        def map_baz; end
      end
    end

    it 'finds all instance methods that starts with map_' do
      expect(mapper_klass.mapping_methods).to     include :map_foo
      expect(mapper_klass.mapping_methods).to_not include :bar
    end

    it 'skips private methods' do
      expect(mapper_klass.private_method_defined?(:map_baz)).to \
        be true
      expect(mapper_klass.mapping_methods).to_not \
        include :map_baz
    end
  end

  describe '.one_to_one_mapping' do
    let(:mapper) do
      define_klass 'Foo', base: Karta::Mapper do
        one_to_one_mapping :foo
      end.new
    end

    it 'defines a mapping method on the instance' do
      expect(mapper).to respond_to :map_foo
    end
  end

  describe '.map' do
    let(:mapper) { double('mapper') }
    let(:from)   { double('from') }
    let(:to)     { double('to') }

    let(:mapper_klass) { define_klass 'Mapper', base: Karta::Mapper }

    it 'instantiates self and runs the map method on the instance' do
      expect(mapper_klass).to receive(:new).and_return(mapper)
      expect(mapper).to       receive(:map).with(from: from, to: to)

      mapper_klass.map(from: from, to: to)
    end
  end
end
