# frozen_string_literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Results
    module Nodes
      class PlayerPassedNode < Dry::Struct
        @@can_handle_player_passed = ::Types.Interface(:handle_player_passed)

        def accept(visitor, **args)
          @can_handle_player_passed.(visitor)
          visitor.handle_player_passed(self, args)
        end
      end
    end
  end
end

