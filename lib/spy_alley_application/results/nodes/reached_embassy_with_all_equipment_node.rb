# frozen_string_literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Results
    module Nodes
      class ReachedEmbassyWithAllEquipmentNode < Dry::Struct
        @@can_handle_reaced_embassy_with_all_equipment =
          ::Types.Interface(:handle_reaced_embassy_with_all_equipment)

        def accept(visitor, **args)
          @can_handle_reached_embassy_with_all_equipment.(visitor)
          visitor.handle_reached_embassy_with_all_equipment(self, args)
        end
      end
    end
  end
end

