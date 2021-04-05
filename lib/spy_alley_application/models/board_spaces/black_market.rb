# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class BlackMarket < Dry::Struct
        @@can_handle_black_market = ::Types.Interface(:handle_black_market)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, ::SpyAlleyApplication::Types::BoardSpace

        def accept(visitor, **args)
          @@can_handle_black_market.(visitor)
          visitor.handle_black_market(self, args)
        end

        def in_spy_alley?;false;end
      end
    end
  end
end

