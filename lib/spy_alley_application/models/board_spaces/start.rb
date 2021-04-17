# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/board_space'

module SpyAlleyApplication
  module Models
    module BoardSpaces
      class Start < Dry::Struct
        @@can_handle_start = ::Types.Interface(:handle_start)
        def self.new(id:, next_space: nil, &block)
          o = Start.allocate
          next_space ||= yield(o)
          o.send(:initialize, **{id: id, next_space: next_space})
          o
        end

        def initialize(id:, next_space: nil, &block)
          @id = ::Types::Coercible::Integer.call(id)
          @next_space = SpyAlleyApplication::Types::BoardSpace.call(next_space)
        end

        def id;@id;end
        def next_space;@next_space;end
        def in_spy_alley?;false;end
        def to_h;{id: id};end

        def accept(visitor, **args)
          @@can_handle_start.(visitor)
          visitor.handle_start(self, args)
        end
      end
    end
  end
end

