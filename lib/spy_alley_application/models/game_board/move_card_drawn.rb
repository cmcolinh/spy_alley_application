# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class MoveCardDrawn
        def call(game_board:)
          player = game_board.current_player
          unaffected_players = game_board.players.reject{|p| p.equal?(player)}
          move_card_pile = game_board.move_card_pile
          # put the first card in the player's move card hand
          player = player.to_h.tap do |p|
            move_cards = (p[:move_cards] + [move_card_pile.first.value]).sort
            p[:move_cards] = move_cards
          end
          # and remove it from the move card pile
          move_card_pile = move_card_pile[1..-1].freeze
          players = unaffected_players.push(player).sort{|p, q| p[:seat] <=> q[:seat]}

          SpyAlleyApplication::Types::GameBoard.call(
            game_board.to_h.tap{|g| g[:players] = players; g[:move_card_pile] = move_card_pile})
        end
      end
    end
  end
end

