# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class EquipmentBought
        include Dry::Initializer.define -> do
          option :next_game_state, type: ::Types::Callable, reader: :private
        end

        def call(game_board:, equipment_bought:)
          player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
          unaffected_players = game_board.pleyers.reject{|p| p.equal?(player)}
          player = player.to_h.tap{|p| p[:equipment] = (p[:equipment] + equipment_bought).sort}
          players = unaffected_players.push(player).sort{|p, q| p[:seat] <=> q[:seat]}
          game_board = SpyAlleyApplication::Types::GameBoard.call(
            game_board.to_h.tap{|g| g[:players] = players})
          next_game_state.(game_board: game_board)
        end
      end
    end
  end
end

