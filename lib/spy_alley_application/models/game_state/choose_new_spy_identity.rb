# frozen string literal: true

require 'dry-struct'
require 'spy_alley_application/models/game_state/start_of_turn'
require 'spy_alley_application/models/game_state/spy_eliminator'

module SpyAlleyApplication
  module Models
    module GameState
      class ChooseNewSpyIdentity < Dry::Struct
        @@can_handle_choose_new_spy_identity =
          ::Types.Interface(:handle_choose_new_spy_identity)

        attribute :name, ::Types::Value('choose_new_spy_identity')
        attribute :seat, ::Types::Coercible::Integer
        attribute :options, ::Types::ArrayOfStrictInteger
        attribute :parent, StartOfTurn | SpyEliminator

        def accept(visitor, **args)
          @@can_handle_choose_new_spy_identity.(visitor)
          visitor.handle_choose_new_spy_identity(self, args)
        end
      end
    end
  end
end

