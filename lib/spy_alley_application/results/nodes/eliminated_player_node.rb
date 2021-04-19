# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/models/player'

module SpyAlleyApplication
  module Results
    module Nodes
      class EliminatedPlayerNode < Dry::Struct
        @@can_handle_eliminated_player = ::Types.Interface(:handle_eliminated_player)
        attribute :eliminating_player, SpyAlleyApplication::Models::Player
        attribute :eliminated_player, SpyAlleyApplication::Models::Player

        def accept(visitor, **args)
          @@can_handle_eliminated_player.(visitor)
          visitor.handle_eliminated_player(self, args)
        end
      end
    end
  end
end

