# frozen_string_literal: true
module Karta
  # Contains the basic functionality for a mapper object,
  # the class is meant to be inherited by a mapper class
  # in order to get the #map method as well as being able
  # to specify one-to-one mappings
  class Mapper

    def map(from:, to:)
      to = to.new if to.is_a?(Class)
      self.class.mapping_methods.each { |m| send(m, from, to) }
      to
    end

    def self.mapping_methods
      public_instance_methods(true).grep(/^map_/)
    end

    def self.one_to_one_mapping(attr)
      define_method("map_#{attr}") do |from, to|
        to.send("#{attr}=", from.send(attr))
      end
    end

    def self.map(from:, to:)
      new.map(from: from, to: to)
    end
  end
end
