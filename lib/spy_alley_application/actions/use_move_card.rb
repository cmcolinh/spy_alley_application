# frozen string literal: true

require 'dry-initializer'

module SpyAlleyApplication
  module Actions
    class UseMoveCard
      include Dry::Initializer.define -> do
        option :get_move_card_used_node, type: ::Types::Callable, reader: :private
        option :move_card_used, type: ::Types::Callable, reader: :private
        option :process_passing_spaces, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, card_to_use:)
        change_orders = change_orders.push(get_move_card_used_node.(
          player_id: game_board.current_player.id,
          card: card_to_use))
        game_board = move_card_used.(game_board: game_board, move_card_used: card_to_use)
        process_passing_spaces.(
          game_board: game_board,
          change_orders: change_orders,
          board_space: game_board.current_player.location,
          spaces_remaining: card_to_use)
      end
    end
  end
end

