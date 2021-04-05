# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class TakeAnotherTurn < Dry::Struct
        @@can_handle_take_another_turn = ::Types.Interface(:handle_take_another_turn)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, ::SpyAlleyApplication::Types::BoardSpace

        def accept(visitor, **args)
          @@can_handle_take_another_turn.(visitor)
          visitor.handle_take_another_turn(self, args)
        end

        def in_spy_alley?;false;end
      end
    end
  end
end

