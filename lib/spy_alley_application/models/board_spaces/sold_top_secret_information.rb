# frozen string_literal: true

require 'dry-initializer'
require 'spy_alley_application/types/board_space'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class SoldTopSecretInformation
        @@can_handle_sold_top_secret_information =
          ::Types.Interface(:handle_sold_top_secret_information)
        include Dry::Initializer.define -> do
          option :id, type: ::Types::Coercible::Integer
          option :next_space, type: SpyAlleyApplication::Types::BoardSpace
          option :money_gained, type: ::Types::Coercible::String
          option :in_spy_alley?, as: :in_spy_alley, type: ::Types::Strict::Bool, reader: false
        end

        def accept(visitor, **args)
          @@can_handle_sold_top_secret_information.(visitor)
          visitor.handle_sold_top_secret_information(self, args)
        end

        def in_spy_alley?;@in_spy_alley;end
      end
    end
  end
end

