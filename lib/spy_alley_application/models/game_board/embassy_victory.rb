# frozen string_literal: true

require 'dry-initializer'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class EmbassyVictory
        def call(game_board:)
          player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
          other_players = game_board.players.reject{|p| p.seat.eql?(game_board.game_state.seat)}

          game_state = {name: 'game_over', reason: {name: 'by_embassy'}, seat: player.seat}

          SpyAlleyApplication::Types::GameBoard.call(
            game_board.to_h.tap{|g| g[:game_state] = game_state})
        end
      end
    end
  end
end

