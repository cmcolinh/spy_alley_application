# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class MoveBack < Dry::Struct
        @@can_handle_move_back = ::Types.Interface(:handle_move_back)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, SpyAlleyApplication::Types::BoardSpace
        attribute :move_back_space, SpyAlleyApplication::Types::BoardSpace

        def accept(visitor, **args)
          @@can_handle_move_back.(visitor)
          visitor.handle_move_back(self, args)
        end

        def in_spy_alley?;false;end
      end
    end
  end
end

