# frozen string literal: true

require 'dry-struct'
require 'spy_alley_application/models/game_state/start_of_turn'
require 'spy_alley_application/models/game_state/spy_eliminator'

module SpyAlleyApplication
  module Models
    module GameState
      class ChooseNewSpyIdentity < Dry::Struct
        new_spy_identity_type = ::Types::Array::of(SpyAlleyApplication::Types::Nationality)
          .constrained(min_size: 2, max_size: 2)
        @@can_handle_choose_new_spy_identity =
          ::Types.Interface(:handle_choose_new_spy_identity)

        attribute :name, ::Types::Value('choose_new_spy_identity')
        attribute :seat, ::Types::Coercible::Integer
        attribute :options, new_spy_identity_type
        attribute :parent, StartOfTurn | SpyEliminator

        def accept(visitor, **args)
          @@can_handle_choose_new_spy_identity.(visitor)
          visitor.handle_choose_new_spy_identity(self, args)
        end
      end
    end
  end
end

