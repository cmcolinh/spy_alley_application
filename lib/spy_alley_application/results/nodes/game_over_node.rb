# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/models/game_state/victory_reason/by_elimination'
require 'spy_alley_application/models/game_state/victory_reason/by_embassy'
require 'spy_alley_application/models/player'

module SpyAlleyApplication
  module Results
    module Nodes
      class GameOverNode < Dry::Struct
        @@can_handle_game_over = ::Types.Interface(:handle_game_over)
        attribute :winning_player, SpyAlleyApplication::Models::Player
        attribute :reason, SpyAlleyApplication::Models::GameState::VictoryReason::ByElimination |
          SpyAlleyApplication::Models::GameState::VictoryReason::ByEmbassy

        def accept(visitor, **args)
          @can_handle_game_over.(visitor)
          visitor.handle_game_over(self, args)
        end
      end
    end
  end
end

