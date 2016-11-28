require 'active_support/inflector'

module Karta
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
