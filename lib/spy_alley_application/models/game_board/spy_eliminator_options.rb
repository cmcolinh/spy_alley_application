# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class SpyEliminatorOptions
        include Dry::Initializer.define -> do
          option :next_game_state, type: ::Types::Callable, reader: :private
        end

        def call(game_board:)
          player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
          targetable_seats = game_board.players
            .select(&:in_spy_alley?)
            .reject{|p| p.equal?(player)}
            .map(&:seat)
            .sort
            .freeze

          if targetable_seats.empty?
            return next_game_state.(game_board: game_board)
          end

          game_state = {
            name: 'spy_eliminator',
            seat: game_board.game_state.seat,
            targetable_seats: targetable_seats,
            parent: game_board.game_state
          }
          SpyAlleyApplication::Types::GameBoard.call(
            game_board.to_h.tap{|g| g[:game_state] = game_state})
        end
      end
    end
  end
end

