# frozen_string_literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Results
    module Nodes
      class ConfiscateMaterialsOptionNode < Dry::Struct
        @@can_handle_confiscate_materials_option =
          ::Types.Interface(:handle_confiscate_materials_option)
        attribute :target_player_id, ::Types::Strict::Integer
        attribute :targetable_equipment, SpyAlleyApplication::Types::ArrayOfEquipment

        def accept(visitor, **args)
          @@can_handle_confiscate_materials_option.(visitor)
          visitor.handle_confiscate_materials_option(self, args)
        end
      end
    end
  end
end

