# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class SellTopSecretInformation < Dry::Struct
        @@can_handle_sell_top_secret_information =
          ::Types.Interface(:handle_sell_top_secret_information)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, SpyAlleyApplication::Types::BoardSpace
        attribute :money_gained, ::Types::Coercible::Integer.constrained(gte: 1)

        def accept(visitor, **args)
          @@can_handle_sell_top_secret_information.(visitor)
          visitor.handle_sell_top_secret_information(self, args)
        end
      end
    end
  end
end

