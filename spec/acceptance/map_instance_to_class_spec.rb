require 'spec_helper'

describe 'mapping from one instance to a class' do

  before do
    define_klass name: "Foo", attrs: [:id, :foo_name]
    define_klass name: "Bar", attrs: [:id, :name]

    define_mapper name: "FooToBarMapper",
                  one_to_one_mappings: [:id],
                  mappings: {
                    name: ->(foo, bar) { bar.name = foo.foo_name }
                  }
  end

  let(:foo) { Foo.new(id: 1, foo_name: "Foo") }

  describe 'using a mapper object' do
    subject { FooToBarMapper.map(from: foo, to: Bar) }

    it 'creates a new instance and maps all fields defined in the mapper' do
      expect(subject.class).to eq Bar
      expect(subject.id).to    eq foo.id
      expect(subject.name).to  eq foo.foo_name
    end
  end

  describe 'using the mapper registry' do

    before do
      Karta.register_mapper FooToBarMapper
    end

    subject { Karta.map(from: foo, to: Bar) }

    it 'creates a new instance and maps all fields defined in the mapper' do
      expect(subject.class).to eq Bar
      expect(subject.id).to    eq foo.id
      expect(subject.name).to  eq foo.foo_name
    end
  end
end
