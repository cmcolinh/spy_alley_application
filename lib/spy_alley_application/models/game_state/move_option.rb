# frozen string literal: true

require 'dry-struct'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Models
    module GameState
      class MoveOption < Dry::Struct
        @@can_handle_move_option = ::Types.Interface(:handle_move_option)

        attribute :name, ::Types::Value('move_option')
        attribute :seat, SpyAlleyApplication::Types::CoercibleIntegerOneToSix
        attribute :options, ::Types::Array::of(::Types::Coercible::Integer)
          .constrained(min_size: 2, max_size: 2)

        def accept(visitor, **args)
          @@can_handle_move_option.(visitor)
          visitor.handle_move_option(self, args)
        end
      end
    end
  end
end

