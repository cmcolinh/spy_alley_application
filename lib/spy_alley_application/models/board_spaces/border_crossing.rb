# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class BorderCrossing < Dry::Struct
        @@can_handle_border_crossing = ::Types.Interface(:handle_draw_move_card)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, ::SpyAlleyApplication::Types::BoardSpace

        def accept(visitor, **args)
          @@can_handle_border_crossing.(visitor)
          visitor.handle_border_crossing(self, args)
        end

        def in_spy_alley?;false;end
      end
    end
  end
end

