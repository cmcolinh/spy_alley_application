# frozen string literal: true

require 'dry-struct'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Models
    class MoveCard < Dry::Struct
      attribute :value, SpyAlleyApplication::Types::CoercibleIntegerOneToSix

      def to_h
        self
      end

      def to_s
        value
      end

      def to_i
        value
      end
      alias_method :transform_values, :to_s
    end
  end
end

