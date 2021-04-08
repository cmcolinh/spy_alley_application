# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class MoneyGainedOrLost
        def call(args = {})
          game_board = args[:game_board]
          player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
          unaffected_players = game_board.players.reject{|p| p.equal?(player)}
          player = player.to_h.tap{|p| p[:money] = p[:money] + money_adjustment}
          players = unaffected_players.push(player).sort{|p, q| p[:seat] <=> q[:seat]}
          game_board = SpyAlleyApplication::Types::GameBoard.call(
            game_board.to_h.tap{|g| g[:players] = players})
          game_board = yield(args.tap{|a| a[:game_board] = game_board}) if block_given?
          game_board
        end
      end
    end
  end
end

