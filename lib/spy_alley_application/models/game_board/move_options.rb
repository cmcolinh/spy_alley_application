# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class MoveOptions
        include Dry::Initializer.define -> do
          option :next_game_state, type: ::Types::Callable, reader: :private
        end

        def call(game_board:, options:)
          game_state = {
            name: 'move_option',
            seat: game_board.game_state.seat,
            options: options
          }
          SpyAlleyApplication::Types::GameBoard.call
            game_board.to_h.tap{|g| g[:game_state] = game_state})
        end
      end
    end
  end
end

