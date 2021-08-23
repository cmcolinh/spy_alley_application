# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/models/player'

module SpyAlleyApplication
  module Results
    module Nodes
      class MoveBackNode < Dry::Struct
        @@can_handle_move_back = ::Types.Interface(:handle_move_back)
        attribute :player, SpyAlleyApplication::Models::Player
        attribute :space_id, ::Types::Strict::Integer

        def accept(visitor, **args)
          @can_handle_move_back.(visitor)
          visitor.handle_move_back(self, args)
        end
      end
    end
  end
end

