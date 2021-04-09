# frozen_string_literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Results
    module Nodes
      class PlayerMovementNode < Dry::Struct
        @@can_handle_player_movement = ::Types.Interface(:handle_player_movement)
        attribute :player_id, ::Types::Strict::Integer
        attribute :space_id, ::Types::Strict::Integer

        def accept(visitor, **args)
          @can_handle_player_movement.(visitor)
          visitor.handle_player_movement(self, args)
        end
      end
    end
  end
end

