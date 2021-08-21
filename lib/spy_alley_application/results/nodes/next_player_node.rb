# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/models/player'

module SpyAlleyApplication
  module Results
    module Nodes
      class NextPlayerNode < Dry::Struct
        @@can_handle_next_player = ::Types.Interface(:handle_next_player)
        attribute :player, SpyAlleyApplication::Models::Player

        def accept(visitor, **args)
          @@can_handle_next_player.(visitor)
          visitor.handle_next_player(self, args)
        end
      end
    end
  end
end

