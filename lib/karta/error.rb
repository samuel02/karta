# frozen_string_literal: true
module Karta
  # Basic class for exceptions in Karta
  class Error < StandardError; end

  # Exception for case when a mapper cannot be found
  class MapperNotFoundError < Error
    def initialize(from, to)
      super("no mapper found (#{from} → #{to})")
    end
  end

  # Exception for case when a mapper has an invalid name
  class InvalidNameError < Error
    def initialize
      super('mapper name must be on format [Foo]To[Bar]Mapper')
    end
  end
end
