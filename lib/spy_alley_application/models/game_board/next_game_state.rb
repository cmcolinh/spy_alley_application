# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/models/game_board'
require 'spy_alley_application/types/game_state'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class NextGameState
        def call(game_board:, target_player_id: nil)
          SpyAlleyApplication::Models::GameBoard::new(
            players: game_board.players,
            move_card_pile: game_board.move_card_pile,
            free_gift_pile: game_board.free_gift_pile,
            game_state: game_board.game_state.accept(self,
              game_board: game_board,
              target_player_id: target_player_id))
        end

        def handle_start_of_turn(node, game_board:)
          all_seats = game_board
            .players
            .select(&:active?)
            .map(&:seat)
            .reject{|seat| seat.eql?(node.seat)}

          next_seat = all_seats.select{|seat| seat > node.seat}.min || all_seats.min

          SpyAlleyApplication::Types::GameState.call(
            name: 'start_of_turn',
            seat: next_seat)
        end
        alias_method :handle_buy_equipment, :handle_start_of_turn
        alias_method :handle_move_action, :handle_start_of_turn
        alias_method :handle_confiscate_materials, :handle_start_of_turn

        def handle_choose_new_spy_identity(node, game_board:)
          node.parent.accept(self, game_board: game_board)
        end

        def handle_spy_eliminator(node, game_board:, target_player_id: nil)
          targeted_player_id = game_board
            .players
            .map(&:id)
            .select{|id| id.eql?(target_player_id)}

          remaining_seats = game_board
            .players
            .select(&:active?)
            .reject{|p| p.id.eql?(targeted_player_id)}
            .map(&:seat)
            .select{|seat| node.targetable_seats.include?(seat)}
            .sort

          if remaining_seats.empty?
            node.parent.accept(self, game_board: game_board)
          else
            SpyAlleyApplication::Types::GameState.call(
              name: 'spy_eliminator',
              seat: node.seat,
              targetable_seats: remaining_seats,
              parent: node.parent)
          end
        end
      end
    end
  end
end

