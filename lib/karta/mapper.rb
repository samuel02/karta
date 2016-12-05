# frozen_string_literal: true
module Karta
  # Contains the basic functionality for a mapper object,
  # the class is meant to be inherited by a mapper class
  # in order to get the `#map method as well as being able
  # to specify one-to-one mappings
  class Mapper
    # Maps an object to another using all mapping methods defined on the mapper.
    # Mapping methods are defined as "one-to-one mappings" by using
    # `.one_to_one_mapping`or by defining methods with names starting with
    # 'map_'. The mapping methods are supposed to take the object which it is
    # mapping from as well as the object which it should map into.
    #
    # @param from [Object] the object to map from
    # @param to [Object, Class] the object or class to map to
    #
    # @return [Object] a new instance of the same type as `to`
    def map(from:, to:)
      to_klass = to.is_a?(Class) ? to : to.class
      _map(from, to_klass.new)
    end

    # Maps an object to another using all mapping methods defined on the mapper.
    # see #map
    #
    # @param from [Object] the object to map from
    # @param to [Object, Class] the object or class to map to
    #
    # @return [Object] a new instance of the same type as `to`
    def map!(from:, to:)
      to = to.new if to.is_a?(Class)
      _map(from, to)
    end

    # Find all mapping methods defined on the mapper.
    #
    # @return [Array<Symbol>] names of all methods beginning with `map_`
    def self.mapping_methods
      public_instance_methods(true).grep(/^map_/)
    end

    # Defines a one-to-one mapping on the mapper as a method.
    #
    # A one-to-one-mapping is a mapping where the attribute names are equal
    # and no transformation is supposed to take place. E.g. `foo.id = bar.id`.
    def self.one_to_one_mapping(attr)
      define_method("map_#{attr}") do |from, to|
        to.send("#{attr}=", from.send(attr))
      end
    end

    # Instantiates a mapper and runs the `#map` method
    #
    # @param from [Object] the object to map from
    # @param to [Object, Class] the object or class to map to
    #
    # @return [Object] a new instance of the same type as `to`
    def self.map(from:, to:)
      new.map(from: from, to: to)
    end

    # Instantiates a mapper and runs the `#map!` method
    #
    # @param from [Object] the object to map from
    # @param to [Object, Class] the object or class to map to
    #
    # @return [Object] a new instance of the same type as `to`
    def self.map!(from:, to:)
      new.map!(from: from, to: to)
    end

    private

    def _map(from, to)
      self.class.mapping_methods.each { |meth| send(meth, from, to) }
      to
    end
  end
end
