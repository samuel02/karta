# frozen_string_literal: true
module DefineConstantMacros
  class DynamicClass
    def initialize(data = {})
      data.each { |attr, val| instance_variable_set("@#{attr}", val) }
    end
  end

  def define_klass(name, attrs: [], inherit_from: DynamicClass, &block)
    klass = Class.new(inherit_from)
    Object.const_set(name, klass)

    klass.class_eval do
      attrs.each { |attr| attr_accessor attr }
    end

    klass.class_eval(&block) if block_given?

    @defined_constants << name
    klass
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
