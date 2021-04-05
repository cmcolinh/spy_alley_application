# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class BuyPassword < Dry::Struct
        @@can_handle_buy_password = ::Types.Interface(:handle_buy_password)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, SpyAlleyApplication::Types::BoardSpace
        attribute :nationality, SpyAlleyApplication::Types::Nationality

        def accept(visitor, **args)
          @@can_handle_buy_password.(visitor)
          visitor.handle_buy_password(self, args)
        end

        def in_spy_alley?;false;end
      end
    end
  end
end

