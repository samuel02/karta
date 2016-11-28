module Karta
  class MapperRegistry
    attr_reader :mappers

    def initialize
      @mappers = []
    end

    def register(mapper:, from_klass: nil, to_klass: nil)
      unless from_klass && to_klass
        from_klass, to_klass = *klasses_from_class_name(mapper)
      end

      mappers.push({
        mapper: mapper,
        from_klass: from_klass,
        to_klass: to_klass
      })
    end

    def find(from_klass:, to_klass:)
      mappers.find(-> {
        raise MapperNotFoundError.new(from_klass, to_klass)
      }) do |mapper|
          mapper[:from_klass] == from_klass && mapper[:to_klass] == to_klass
      end.fetch(:mapper)
    end

    private

    def klasses_from_class_name(klass_name)
      raise InvalidNameError unless klass_name.to_s =~ /.*To.*Mapper/

      klass_name.to_s
                .gsub('Mapper', '')
                .split("To")
                .map(&:constantize)
    end
  end
end
