# frozen_string_literal: true
require 'active_support/inflector'

module Karta
  # Contains the basic functionality for a mapper object,
  # the module is meant to be included in a mapper class
  # in order to get the #map method as well as being able
  # to specify one-to-one mappings
  module Mapper
    def self.included(base)
      base.extend(ClassMethods)
    end

    def map(from:, to:)
      to = to.new if to.is_a?(Class)
      mapping_methods.each { |m| send(m, from, to) }
      to
    end

    def mapping_methods
      self.class.public_instance_methods(true)
          .grep(/^map_/)
          .map(&:to_s)
    end

    # The class methods will be extended to the class
    # when the Karta::Mapper module is included
    module ClassMethods
      def one_to_one_mapping(attr)
        define_method("map_#{attr}") do |from, to|
          to.send("#{attr}=", from.send(attr))
        end
      end

      def map(from:, to:)
        new.map(from: from, to: to)
      end
    end
  end
end
