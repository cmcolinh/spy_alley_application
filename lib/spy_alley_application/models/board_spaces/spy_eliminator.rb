# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class SpyEliminator < Dry::Struct
        @@can_handle_spy_eliminator = ::Types.Interface(:handle_spy_eliminator)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, ::SpyAlleyApplication::Types::BoardSpace

        def accept(visitor, **args)
          @@can_handle_spy_eliminator.(visitor)
          visitor.handle_spy_eliminator(self, args)
        end

        def in_spy_alley?;true;end
      end
    end
  end
end

