# frozen string literal: true

require 'dry-struct'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Models
    module GameState
      class ConfiscateMaterials < Dry::Struct
        class ConfiscationTarget < Dry::Struct
          attribute :seat, SpyAlleyApplication::Types::CoercibleIntegerOneToSix
          attribute :equipment, SpyAlleyApplication::Types::ArrayOfEquipment
        end

        @@can_handle_confiscate_materials = ::Types.Interface(:handle_confiscate_materials)

        attribute :name, ::Types::Value('confiscate_materials')
        attribute :seat, SpyAlleyApplication::Types::CoercibleIntegerOneToSix
        attribute :targets, ::Types::Array::of(ConfiscationTarget)

        def accept(visitor, **args)
          @@can_handle_confiscate_materials.(visitor)
          visitor.handle_confiscate_materials(self, args)
        end
      end
    end
  end
end

