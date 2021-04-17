# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class SoldTopSecretInformation < Dry::Struct
        @@can_handle_sold_top_secret_information =
          ::Types.Interface(:handle_sold_top_secret_information)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, SpyAlleyApplication::Types::BoardSpace
        attribute :money_gained, ::Types::CoercibleNonnegativeInteger
        attribute :in_spy_alley, ::Types::Strict::Bool
        alias_method :in_spy_alley?, :in_spy_alley

        def accept(visitor, **args)
          @@can_handle_sold_top_secret_information.(visitor)
          visitor.handle_sold_top_secret_information(self, args)
        end
      end
    end
  end
end

