# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class MoveCardUsed
        def call(game_board:, move_card_used:)
          player = game_board.current_player
          unaffected_players = game_board.players.reject{|p| p.equal?(player)}
          move_card_pile = game_board.move_card_pile
          # remove one copyof the move_card_used from the player's move card hand
          player = player.to_h.tap do |p|
            p[:move_cards].delete_at(p[:move_cards].index(move_card_used))
            p[:move_cards] = p[:move_cards].sort
          end
          # and place at the bottom (end) of the move card pile
          move_card_pile = (move_card_pile + [move_card_used]).freeze
          players = unaffected_players.push(player).sort{|p, q| p[:seat] <=> q[:seat]}

          SpyAlleyApplication::Types::GameBoard.call(
            game_board.to_h.tap{|g| g[:players] = players; g[:move_card_pile] = move_card_pile})
        end
      end
    end
  end
end

