# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/models/player'
require 'spy_alley_application/models/acquisition_method/by_confiscation'
require 'spy_alley_application/models/acquisition_method/by_free_gift'
require 'spy_alley_application/models/acquisition_method/by_purchase'

module SpyAlleyApplication
  module Results
    module Nodes
      class WildCardGainedNode < Dry::Struct
        @@can_handle_wild_card_gained = ::Types.Interface(:handle_wild_card_gained)
        attribute :player, SpyAlleyApplication::Models::Player
        attribute :number_gained, ::Types::CoercibleNonnegativeInteger
        attribute :reason, SpyAlleyApplication::Models::AcquisitionMethod::ByConfiscation |
          SpyAlleyApplication::Models::AcquisitionMethod::ByFreeGift |
          SpyAlleyApplication::Models::AcquisitionMethod::ByPurchase

        def accept(visitor, **args)
          @can_handle_wild_card_gained.(visitor)
          visitor.handle_wild_card_gained(self, args)
        end
      end
    end
  end
end

