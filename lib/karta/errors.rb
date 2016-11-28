module Karta
  class MapperNotFoundError < StandardError
    def initialize(from, to)
      super("no mapper found (#{from.to_s} → #{to.to_s})")
    end
  end

  class InvalidNameError < StandardError
    def initialize
      super("mapper name must be on format [Foo]To[Bar]Mapper")
    end
  end
end
