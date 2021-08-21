# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/models/acquisition_method/by_passing_start'
require 'spy_alley_application/models/acquisition_method/by_selling_top_secret_information'
require 'spy_alley_application/models/player'

module SpyAlleyApplication
  module Results
    module Nodes
      class MoneyGainedNode < Dry::Struct
        @@can_handle_money_gained = ::Types.Interface(:handle_money_gained)
        attribute :player, SpyAlleyApplication::Models::Player
        attribute :money_gained, ::Types::CoercibleNonnegativeInteger
        attribute :reason, SpyAlleyApplication::Models::AcquisitionMethod::ByPassingStart |
          SpyAlleyApplication::Models::AcquisitionMethod::BySellingTopSecretInformation

        def accept(visitor, **args)
          @can_handle_money_gained.(visitor)
          visitor.handle_money_gained(self, args)
        end
      end
    end
  end
end

