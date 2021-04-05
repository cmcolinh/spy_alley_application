# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class ConfiscateMaterials < Dry::Struct
        @@can_handle_confiscate_materials = ::Types.Interface(:handle_confiscate_materials)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, ::SpyAlleyApplication::Types::BoardSpace

        def accept(visitor, **args)
          @@can_handle_confiscate_materials.(visitor)
          visitor.handle_confiscate_materials(self, args)
        end

        def in_spy_alley?;true;end
      end
    end
  end
end

