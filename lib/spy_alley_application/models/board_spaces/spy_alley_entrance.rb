require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class SpyAlleyEntrance
        @@can_handle_spy_alley_entrance = ::Types.Interface(:handle_spy_alley_entrance)
        def initialize(id:, next_space:, branch_space: nil, &block)
          @id = ::Types::Coercible::Integer.call(id)
          @next_space = SpyAlleyApplication::Types::BoardSpace.call(next_space)
          @branch_space = SpyAlleyApplication::Types::BoardSpace.call(branch_space || yield(self))
        end

        def id;@id;end
        def next_space;@next_space;end
        def branch_space;@branch_space;end
        def in_spy_alley?;false;end

        def accept(visitor, **args)
          @@can_handle_spy_alley_entrance.(visitor)
          visitor.handle_spy_alley_entrance(self, args)
        end
      end
    end
  end
end

