# frozen string literal: true

require 'dry-struct'
require 'spy_alley_application/models/game_state/start_of_turn'

module SpyAlleyApplication
  module Models
    module GameState
      class SpyEliminator < Dry::Struct
        @@can_handle_spy_eliminator = ::Types.Interface(:handle_spy_eliminator)

        attribute :name, ::Types.Value('spy_eliminator')
        attribute :seat, ::Types::Coercible::Integer
        attribute :targetable_seats, ::Types::ArrayOfStrictInteger
        attribute :parent, SpyAlleyApplication::Models::GameState::StartOfTurn

        def accept(visitor, **args)
          @@can_handle_spy_eliminator.(visitor)
          visitor.handle_spy_eliminator(self, args)
        end
      end
    end
  end
end

