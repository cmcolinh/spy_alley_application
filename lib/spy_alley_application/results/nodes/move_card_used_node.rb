# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Results
    module Nodes
      class MoveCardUsedNode < Dry::Struct
        @@can_handle_move_card_used = ::Types.Interface(:handle_move_card_used)
        attribute :player_id, ::Types::Coercible::Integer
        attribute :card, SpyAlleyApplication::Types::CoercibleIntegerOneToSix

        def accept(visitor, **args)
          @can_handle_move_card_used.(visitor)
          visitor.handle_card_card_used(self, args)
        end
      end
    end
  end
end

