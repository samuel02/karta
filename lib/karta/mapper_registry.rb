# frozen_string_literal: true
module Karta
  # Simple collection class for mappers
  class MapperRegistry
    attr_reader :mappers

    def initialize
      @mappers = []
    end

    # Register a mapper to the registry.
    #
    # If no from_klass or to_klass are specified it will try to parse this
    # from the class name of the mapper. This assumes that the class name
    # of the mapper is on the form `[from class]To[to class]Mapper`, e.g.
    # `FooToBarMapper`. For obvious reasons this makes it hard to handle
    # cases where one of the classes is namespaced, e.g. `Baz::Bar`. For
    # those cases the `from_klass` and `to_klass` must be specified.
    #
    # @param mapper [Karta::Mapper] the mapper to register
    # @param from_klass [Class] the class the mapper is supposed to map from
    # @param to_klass [Class] the class the mapper is supposed to map to
    #
    # @raise [InvalidNameError] if no `from_klass` or `to_klass` is specified
    #   and the class name of the mapper does not follow the correct format.
    #
    # @return [MapperRegistry] the mapper registry after the mapper has been
    #   added
    def register(mapper:, from_klass: nil, to_klass: nil)
      unless from_klass && to_klass
        from_klass, to_klass = *klasses_from_class_name(mapper.to_s)
      end

      mappers.push(mapper: mapper,
                   from_klass: from_klass,
                   to_klass: to_klass)

      self
    end

    # Find a mapper in the registry
    #
    # @param from_klass [Class] the class the mapper is supposed to map from
    # @param to_klass [Class] the class the mapper is supposed to map to
    #
    # @raise [MapperNotFoundError] if no applicable mapper is found
    #
    # @return [Karta::Mapper] the found mapper
    def find(from_klass:, to_klass:)
      mappers.find(lambda do
        raise MapperNotFoundError.new(from_klass, to_klass)
      end) do |mapper|
        mapper[:from_klass] == from_klass && mapper[:to_klass] == to_klass
      end.fetch(:mapper)
    end

    private

    def klasses_from_class_name(klass_name)
      raise InvalidNameError unless klass_name =~ /.*To.*Mapper/

      klass_name.gsub('Mapper', '')
                .split('To')
                .map(&Kernel.method(:const_get))
    end
  end
end
