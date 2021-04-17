# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class MoveCardDrawn
        include Dry::Initializer.define -> do
          option :next_game_state, type: ::Types::Callable, reader: :private
        end

        def call(game_board:)
          player = game_board.current_player
          unaffected_players = game_board.players.reject{|p| p.equal?(player)}
          move_card_pile = game_board.move_card_pile
          # put the first card in the player's move card hand
          player = player.to_h.tap{|p| p[:move_cards].push(move_card_pile.first).sort}
          # and remove it from the move card pile
          move_card_pile = move_card_pile[1..-1].freeze
          players = unaffected_players.push(player).sort{|p, q| p[:seat] <=> q[:seat]}

          game_board = SpyAlleyApplication::Types::GameBoard.call(
            game_board.to_h.tap{|g| g[:players] = players; g[:move_card_pile] = move_card_pile})
          next_game_state.(game_board: game_board)
        end
      end
    end
  end
end

