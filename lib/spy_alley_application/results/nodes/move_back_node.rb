# frozen_string_literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Results
    module Nodes
      class MoveBackNode < Dry::Struct
        @@can_handle_money_gained = ::Types.Interface(:handle_move_back)
        attribute :player_id, ::Types::Coercible::Integer
        attribute :player_moved, ::Types.Interface(:accept)

        def accept(visitor, **args)
          @can_handle_move_back.(visitor)
          visitor.handle_move_back(self, args)
        end
      end
    end
  end
end

