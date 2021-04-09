require 'dry-initializer'

module SpyAlleyApplication
  module Results
    class ProcessLandingOnSpace
      include Dry::Initializer.define -> do
        option :get_player_movement_node, type: ::Types::Callable, reader: :private
        option :player_moved, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, game_space:)
        player = game_board.current_player
        change_orders = change_orders.push(get_player_movement_node.(
          player_id: player.id,
          space_id: game_space.id)
        game_board = player_moved.(game_board: game_board, new_location: game_space)
        game_space.accept(self, game_board: game_board, change_orders: change_orders)
      end

      def handle_black_market(board_space, game_board:, change_orders:)
      end

      def handle_border_crossing(board_space, game_board:, change_orders:)
      end

      def handle_buy_equipment(board_space, game_board:, change_orders:)
      end

      def handle_buy_password(board_space, game_board:, change_orders:)
      end

      def handle_confiscate_materials(board_space, game_board:, change_orders:)
      end

      def handle_draw_free_gift(board_space, game_board:, change_orders:)
      end

      def handle_draw_move_card(board_space, game_board:, change_orders:)
      end

      def handle_embassy(board_space, game_board:, change_orders:)
      end

      def handle_move_back(board_space, game_board:, change_orders:)
      end

      def handle_sold_top_secret_information(board_space, game_board:, change_orders:)
      end

      def handle_spy_alley_entrance(board_space, game_board:, change_orders:)
      end

      def handle_spy_eliminator(board_space, game_board:, change_orders:)
      end

      def handle_start(board_space, game_board:, change_orders:)
      end

      def handle_take_another_turn(board_space, game_board:, change_orders:)
      end
    end
  end
end

