# frozen_string_literal: true
require 'karta/version'
require 'karta/mapper_registry'
require 'karta/error'
require 'karta/mapper'

# The module that contains everything relating to Karta
#
# @author Samuel Nilsson <mail@samuelnilsson.me>
module Karta
  # Holds the global registry of mappers
  #
  # @return [MapperRegistry] the mapper registry
  def self.mapper_registry
    @mapper_registry ||= MapperRegistry.new
  end

  # Register a new mapper to the registry
  #
  # @param mapper [Karta::Mapper] the mapper to be registered
  # @param from_klass [Class] the class the mapper is supposed to map from
  # @param to_klass [Class] the class the mapper is supposed to map to
  #
  # @return [MapperRegistry]
  def self.register_mapper(mapper, from_klass: nil, to_klass: nil)
    mapper_registry.register(mapper: mapper,
                             from_klass: from_klass,
                             to_klass: to_klass)
  end

  # Map an object to another using a registered mapper. Returns a new instance
  # of the mapped object.
  #
  # @param from [Object] the object to map from
  # @param to [Object, Class] the object or class to map to
  #
  # @raise [ArgumentError] if trying to map from a class rather than an instance
  #
  # @return [Object] a new instance of the same type as `to`
  def self.map(from:, to:)
    to, to_klass, from, from_klass = *_handle_map_args(from, to)

    mapper_registry.find(from_klass: from_klass, to_klass: to_klass)
                   .map(from: from, to: to)
  end

  # Map an object to another using a registered mapper. Performs the mapping
  # "in place" and thus modifies the 'to' object and overrides attributes.
  #
  # @param from [Object] the object to map from
  # @param to [Object, Class] the object or class to map to
  #
  # @raise [ArgumentError] if trying to map from a class rather than an instance
  #
  # @return [Object] returns modified version of 'to'
  def self.map!(from:, to:)
    to, to_klass, from, from_klass = *_handle_map_args(from, to)

    mapper_registry.find(from_klass: from_klass, to_klass: to_klass)
                   .map!(from: from, to: to)
  end

  # @api private
  def self._handle_map_args(from, to)
    raise ArgumentError, 'cannot map from a class' if from.is_a?(Class)
    to_klass = to.is_a?(Class) ? to : to.class
    [to, to_klass, from, from.class]
  end
end
