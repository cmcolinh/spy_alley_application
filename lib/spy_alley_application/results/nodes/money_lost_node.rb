# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/models/player'

module SpyAlleyApplication
  module Results
    module Nodes
      class MoneyLostNode < Dry::Struct
        @@can_handle_money_lost = ::Types.Interface(:handle_money_lost)
        attribute :player, SpyAlleyApplication::Models::Player
        attribute :money_lost, ::Types::CoercibleNonnegativeInteger

        def accept(visitor, **args)
          @can_handle_money_lost.(visitor)
          visitor.handle_money_lost(self, args)
        end
      end
    end
  end
end

