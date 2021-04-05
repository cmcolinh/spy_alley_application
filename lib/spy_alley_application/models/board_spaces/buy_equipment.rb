# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'
require 'spy_alley_application/types/equipment_type'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class BuyEquipment < Dry::Struct
        @@can_handle_buy_equipment = ::Types.Interface(:handle_buy_equipment)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, SpyAlleyApplication::Types::BoardSpace
        attribute :type, SpyAlleyApplication::Types::EquipmentType

        def accept(visitor, **args)
          @@can_handle_buy_equipment.(visitor)
          visitor.handle_buy_equipment(self, args)
        end

        def in_spy_alley?;false;end
      end
    end
  end
end

