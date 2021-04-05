# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class DrawFreeGift < Dry::Struct
        @@can_handle_draw_free_gift = ::Types.Interface(:handle_draw_free_gift)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, ::SpyAlleyApplication::Types::BoardSpace

        def accept(visitor, **args)
          @@can_handle_draw_free_gift.(visitor)
          visitor.handle_draw_free_gift(self, args)
        end

        def in_spy_alley?;false;end
      end
    end
  end
end

