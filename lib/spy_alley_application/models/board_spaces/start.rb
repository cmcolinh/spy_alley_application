# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class Start
        @@can_handle_start = ::Types.Interface(:handle_start)
        def initialize(id:, next_space: nil, &block)
          @id = ::Types::Coercible::Integer.call(id)
          @next_space = SpyAlleyApplication::Types::BoardSpace.call(next_space || yield(self))
        end

        def id;@id;end
        def next_space;@next_space;end
        def in_spy_alley?;false;end

        def accept(visitor, **args)
          @@can_handle_start.(visitor)
          visitor.handle_start(self, args)
        end
      end
    end
  end
end

