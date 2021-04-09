# frozen_string_literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Results
    module Nodes
      class MoveOptionNode < Dry::Struct
        @@can_handle_move_option = ::Types.Interface(:handle_move_option)
        attribute :options, ::Types::ArrayOfStrictInteger

        def accept(visitor, **args)
          @can_handle_move_option.(visitor)
          visitor.handle_move_option(self, args)
        end
      end
    end
  end
end

