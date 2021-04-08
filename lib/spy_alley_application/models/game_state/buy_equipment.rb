# frozen string literal: true

require 'dry-struct'
require 'spy_alley_application/types/array_of_equipment'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Models
    module GameState
      class BuyEquipment < Dry::Struct
        @@can_handle_buy_equipment = ::Types.Interface(:handle_buy_equipment)

        attribute :name, ::Types::Value('buy_equipment')
        attribute :seat, SpyAlleyApplication::Types::CoercibleIntegerOneToSix
        attribute :options, SpyAlleyApplication::Types::ArrayOfEquipment
        attribute :limit, ::Types::CoercibleNonnegativeInteger

        def accept(visitor, **args)
          @@can_handle_buy_equipment.(visitor)
          visitor.handle_buy_equipment(self, args)
        end
      end
    end
  end
end

