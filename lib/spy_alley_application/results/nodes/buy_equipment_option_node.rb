# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/array_of_equipment'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Results
    module Nodes
      class BuyEquipmentOptionNode < Dry::Struct
        @@can_handle_buy_equipment_option = ::Types.Interface(:handle_buy_equipment_option)
        attribute :options, SpyAlleyApplication::Types::ArrayOfEquipment
        attribute :limit, ::Types::CoercibleNonnegativeInteger

        def accept(visitor, **args)
          @can_handle_buy_equipment_option.(visitor)
          visitor.handle_buy_equipment_option(self, args)
        end
      end
    end
  end
end

