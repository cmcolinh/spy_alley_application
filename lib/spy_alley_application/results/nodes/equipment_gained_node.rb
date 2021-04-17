# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/models/acquisition_method/by_confiscation'
require 'spy_alley_application/models/acquisition_method/by_free_gift'
require 'spy_alley_application/models/acquisition_method/by_purchase'
require 'spy_alley_application/types/array_of_equipment'

module SpyAlleyApplication
  module Results
    module Nodes
      class EquipmentGainedNode < Dry::Struct
        @@can_handle_equipment_gained = ::Types.Interface(:handle_equipment_gained)
        attribute :player_id, ::Types::Coercible::Integer
        attribute :equipment, SpyAlleyApplication::Types::ArrayOfEquipment
        attribute :reason, SpyAlleyApplication::Models::AcquisitionMethod::ByConfiscation |
          SpyAlleyApplication::Models::AcquisitionMethod::ByFreeGift |
          SpyAlleyApplication::Models::AcquisitionMethod::ByPurchase

        def accept(visitor, **args)
          @can_handle_equipment_gained.(visitor)
          visitor.handle_equipment_gained(self, args)
        end
      end
    end
  end
end

