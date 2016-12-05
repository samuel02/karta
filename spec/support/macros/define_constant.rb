# frozen_string_literal: true
module DefineConstantMacros
  # Simple class used for making flexible objects
  # in tests
  class FlexibleObject
    def initialize(data = {})
      data.each { |attr, val| instance_variable_set("@#{attr}", val) }
    end
  end

  def define_klass(path, attrs: [], base: FlexibleObject, &block)
    namespace, class_name = *constant_path(path)
    klass = Class.new(base)
    namespace.const_set(class_name, klass)

    klass.class_eval do
      attrs.each { |attr| attr_accessor attr }
    end

    klass.class_eval(&block) if block_given?

    @defined_constants << path
    klass
  end

  def constant_path(constant_name)
    names = constant_name.split('::')
    class_name = names.pop
    namespace = names.inject(Object) { |acc, elem| acc.const_get(elem) }
    [namespace, class_name]
  end

  def default_constants
    @defined_constants ||= []
  end

  def clear_generated_constants
    @defined_constants.reverse.each do |path|
      namespace, class_name = *constant_path(path)
      namespace.send(:remove_const, class_name)
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
