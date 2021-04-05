# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class DrawMoveCard < Dry::Struct
        @@can_handle_draw_move_card = ::Types.Interface(:handle_draw_move_card)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, SpyAlleyApplication::Types::BoardSpace

        def accept(visitor, **args)
          @@can_handle_draw_move_card.(visitor)
          visitor.handle_draw_move_card(self, args)
        end

        def in_spy_alley?;false;end
      end
    end
  end
end

