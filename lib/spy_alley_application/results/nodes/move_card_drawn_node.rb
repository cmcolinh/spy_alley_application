# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Results
    module Nodes
      class MoveCardDrawnNode < Dry::Struct
        @@can_handle_move_card_drawn = ::Types.Interface(:handle_move_card_drawn)
        attribute :player_id, ::Types::Coercible::Integer
        attribute :card, SpyAlleyApplication::Types::CoercibleIntegerOneToSix

        def accept(visitor, **args)
          @can_handle_move_card_drawn.(visitor)
          visitor.handle_card_card_drawn(self, args)
        end
      end
    end
  end
end

