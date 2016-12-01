# frozen_string_literal: true
module DefineConstantMacros
  def define_klass(name:, attrs: [], &block)
    klass = Class.new(DynamicClass)
    Object.const_set(name, klass)

    klass.class_eval do
      attrs.each { |attr| attr_accessor attr }
    end

    klass.class_eval(&block) if block_given?

    @defined_constants << name
    klass
  end

  def define_mapper(name:, one_to_one_mappings: [], mappings: [])
    define_klass name: name do
      include Karta::Mapper

      one_to_one_mappings.each do |attr|
        one_to_one_mapping attr
      end

      mappings.each do |mapping_method, proc|
        define_method "map_#{mapping_method}", proc
      end
    end
  end

  def default_constants
    @defined_constants ||= []
  end

  def clear_generated_constants
    @defined_constants.reverse.each do |name|
      Object.send(:remove_const, name)
    end

    @defined_constants.clear
  end

  class DynamicClass
    def initialize(data = {})
      data.each { |attr, val| instance_variable_set("@#{attr}", val) }
    end
  end

  RSpec.configure do |config|
    config.include DefineConstantMacros

    config.before do
      default_constants
    end

    config.after do
      clear_generated_constants
    end
  end
end
