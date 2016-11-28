require "karta/version"
require "karta/mapper_registry"
require "karta/errors"
require "karta/mapper"

module Karta

  def self.mapper_registry
    @mapper_registry ||= MapperRegistry.new
  end

  def self.register_mapper(mapper, from_klass: nil, to_klass: nil)
    mapper_registry.register(mapper: mapper,
                             from_klass: from_klass,
                             to_klass: to_klass)
  end

  def self.map(from:, to:)
    to, to_klass, from, from_klass = *_handle_map_args(from, to)

    mapper_registry.find(from_klass: from_klass, to_klass: to_klass)
                   .map(from: from, to: to)
  end

  def self._handle_map_args(from, to)
    raise ArgumentError.new('cannot map from a class') if from.is_a?(Class)
    to_klass = to.is_a?(Class) ? to : to.class
    [to, to_klass, from, from.class]
  end
end
