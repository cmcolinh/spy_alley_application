# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/models/game_board'
require 'spy_alley_application/types/equipment'
require 'spy_alley_application/types/game_state'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class EliminatePlayer
        def call(game_board:, eliminating_player:, eliminated_player:)
          unaffected_players = game_board
            .players
            .reject{|player| [eliminating_player, eliminated_player].include?(player)}

          game_state = get_game_state(unaffected_players, eliminating_player)

          eliminating_player = get_eliminating_player(eliminating_player, eliminated_player)

          eliminated_player = get_eliminated_player(eliminated_player)

          players = unaffected_players
            .push(eliminating_player)
            .push(eliminated_player)
            .sort{|p, q| p.seat <=> q.seat}
            .freeze

          get_new_game_board(game_board, players, game_state)
        end

        private
        def get_game_state(unaffected_players, eliminating_player)
          # If none of the other players are in the game, then the game must be over
          if unaffected_players.none?(&:active?)
            {name: 'game_over', reason: {name: 'by_elimination'}, seat: eliminating_player.seat}
          else
            {
              name: 'choose_new_spy_identity',
              seat: eliminating_player.seat,
              options: [eliminating_player.spy_identity, eliminated_player.spy_identity].freeze,
              parent: game_board.game_state
            }
          end
        end

        def get_eliminating_player(eliminating_player, eliminated_player)
          new_equipment = eliminating_player.equipment.map(&:to_s)
          new_equipment = new_equipment + (eliminated_player.equipment.map(&:to_s))
          new_equipment = new_equipment.uniq.sort
          new_move_cards = eliminating_player.move_cards.map(&:value)
          new_move_cards = new_move_cards + (eliminated_player.move_cards.map(&:value))
          new_move_cards = new_move_cards.sort
          new_money = eliminating_player.money + eliminated_player.money
          new_wild_cards = eliminating_player.wild_cards + eliminated_player.wild_cards

          new_values = eliminating_player.to_h
          new_values[:equipment] = new_equipment
          new_values[:money] = new_money
          new_values[:move_cards] = new_move_cards
          new_values[:wild_cards] = new_wild_cards

          SpyAlleyApplication::Types::Player.call(new_values)
        end

        def get_eliminated_player(eliminated_player)
          SpyAlleyApplication::Types::Player.call(
            id: eliminated_player.id,
            seat: eliminated_player.seat,
            location: eliminated_player.location,
            spy_identity: eliminated_player.spy_identity,
            money: 0,
            move_cards: [].freeze,
            equipment: [].freeze,
            wild_cards: 0,
            active?: false)
        end

        def get_new_game_board(game_board, players, game_state)
          SpyAlleyApplication::Models::GameBoard::new(
            players: players,
            move_card_pile: game_board.move_card_pile,
            free_gift_pile: game_board.free_gift_pile,
            game_state: game_state)
        end
      end
    end
  end
end

