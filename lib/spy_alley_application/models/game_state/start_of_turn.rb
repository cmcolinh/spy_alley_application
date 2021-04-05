# frozen string literal: true

require 'dry-struct'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Models
    module GameState
      class StartOfTurn < Dry::Struct
        @@can_handle_start_of_turn = ::Types.Interface(:handle_start_of_turn)

        attribute :name, ::Types::Value('start_of_turn')
        attribute :seat, SpyAlleyApplication::Types::CoercibleIntegerOneToSix

        def accept(visitor, **args)
          @@can_handle_start_of_turn.(visitor)
          visitor.handle_start_of_turn(self, args)
        end
      end
    end
  end
end

