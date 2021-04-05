# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class Embassy < Dry::Struct
        @@can_handle_embassy = ::Types.Interface(:handle_embassy)
        attribute :id, ::Types::Coercible::Integer
        attribute :next_space, SpyAlleyApplication::Types::BoardSpace
        attribute :nationality, SpyAlleyApplication::Types::Nationality

        def accept(visitor, **args)
          @@can_handle_embassy.(visitor)
          visitor.handle_embassy(self, args)
        end

        def in_spy_alley?;true;end
      end
    end
  end
end

