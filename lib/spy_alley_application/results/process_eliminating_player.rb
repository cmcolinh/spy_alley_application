# frozen_string_literal: true

require 'dry-initializer'

module SpyAlleyApplication
  module Results
    class ProcessEliminatingPlayer
      include Dry::Initializer.define -> do
        option :get_eliminated_player_node, type: ::Types::Callable, reader: :private
        option :get_game_over_node, type: ::Types::Callable, reader: :private
        option :get_result_game_board_node, type: ::Types::Callable, reader: :private
        option :eliminate_player, type: ::Types::Callable, reader: :private
        option :process_next_turn_options, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, eliminating_player:, eliminated_player:)
        change_orders = change_orders.push(get_eliminated_player_node.(
          eliminating_player: eliminating_player,
          eliminated_player: eliminated_player))
        game_board = eliminate_player.(
          game_board: game_board,
          eliminating_player: eliminating_player,
          eliminated_player: eliminated_player)
        if game_board.players.count(&:active) < 2
          change_orders = change_orders.push(get_game_over_node.(
            winning_player_id: eliminating_player.id,
            reason: {name: 'by_elimination'}))
        end
        process_next_turn_options.(
          game_board: game_board,
          change_orders: change_orders.push(get_result_game_board_node.(game_board: game_board)))
      end
    end
  end
end

