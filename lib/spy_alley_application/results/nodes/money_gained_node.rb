# frozen_string_literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Results
    module Nodes
      class MoneyGainedNode < Dry::Struct
        @@can_handle_money_gained = ::Types.Interface(:handle_money_gained)
        attribute :player_id, ::Types::Coercible::Integer
        attribute :money_gained, ::Types::CoercibleNonnegativeInteger
        attribute :reason, ::Types::String::enum('passing_start',
          'sold_top_secret_information',
          'equipment_confiscated',
          'eliminated_spy')

        def accept(visitor, **args)
          @can_handle_money_gained.(visitor)
          visitor.handle_money_gained(self, args)
        end
      end
    end
  end
end

