# frozen_string_literal: true
require 'spec_helper'

describe Karta::Mapper do
  describe '.included' do
    let(:base) { double('base') }

    it 'extends the class with ClassMethods' do
      expect(base).to receive(:extend).with(Karta::Mapper::ClassMethods)
      Karta::Mapper.included(base)
    end
  end

  describe '#map' do
    before do
      define_klass name: 'Foo'
      define_klass name: 'Bar'
    end

    let(:mapper) { Class.new(Object).include(Karta::Mapper).new }

    before do
      allow(mapper).to receive(:mapping_methods).and_return([:method])
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
    let(:mapper) do
      Class.new(Object) do
        include Karta::Mapper
        def map_foo; end
        def bar; end
        private
        def map_baz; end
      end.new
    end

    it 'finds all instance methods that starts with map_' do
      expect(mapper.mapping_methods).to     include :map_foo
      expect(mapper.mapping_methods).to_not include :bar
    end

    it 'skips private methods' do
      expect(mapper.class.private_method_defined?(:map_baz)).to \
        be true
      expect(mapper.mapping_methods).to_not \
        include :map_baz
    end
  end

  describe Karta::Mapper::ClassMethods do
    describe '.one_to_one_mapping' do
      let(:mapper) do
        Class.new(Object) do
          include Karta::Mapper
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

      let(:klass) do
        Class.new(Object) do
          include Karta::Mapper
        end
      end

      it 'instantiates self and runs the map method on the instance' do
        expect(klass).to receive(:new).and_return(mapper)
        expect(mapper).to receive(:map).with(from: from, to: to)

        klass.map(from: from, to: to)
      end
    end
  end
end
