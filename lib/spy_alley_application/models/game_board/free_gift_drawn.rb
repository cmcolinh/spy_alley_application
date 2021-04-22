# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class FreeGiftDrawn
        def call(game_board:)
          player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
          unaffected_players = game_board.players.reject{|p| p.equal?(player)}
          free_gift_pile = game_board.free_gift_pile
          top_free_gift = free_gift_pile.first
          if top_free_gift.wild_card?
            player = player.to_h.tap{|p| p[:wild_cards] += 1}.to_h
            free_gift_pile = free_gift_pile[1..-1]
          else
            player = add_equipment(player, top_free_gift)
            free_gift_pile = free_gift_pile[1..-1].push(top_free_gift).freeze
          end
          players = unaffected_players.push(player).sort{|p, q| p[:seat] <=> q[:seat]}
          SpyAlleyApplication::Types::GameBoard.call(
            game_board.to_h.tap{|g| g[:players] = players; g[:free_gift_pile] = free_gift_pile})
        end

        private
        def add_equipment(player, equipment)
          if player.equipment.none?{|e| e.equal?(equipment)}
            player.to_h.tap{|p| p[:equipment] = p[:equipment].push(equipment).sort}
          else
            player
          end
        end
      end
    end
  end
end

