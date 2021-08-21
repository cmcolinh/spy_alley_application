require 'dry-initializer'
require 'spy_alley_application/models/game_state/buy_equipment'

module SpyAlleyApplication
  module Results
    class ProcessPassingSpaces
      include Dry::Initializer.define -> do
        option :get_money_gained_node, type: ::Types::Callable, reader: :private
        option :money_gained_or_lost, type: ::Types::Callable, reader: :private
        option :process_landing_on_space, type: ::Types::Callable, reader: :private
        option :process_move_options, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, board_space:, spaces_remaining:)
        board_space = board_space.next_space
        if spaces_remaining.eql?(1)
          process_landing_on_space.(
            game_board: game_board,
            change_orders: change_orders,
            space_id: board_space.id)
        else
          board_space.accept(self,
            game_board: game_board,
            change_orders: change_orders,
            spaces_remaining: spaces_remaining)
        end
      end

      def handle_start(board_space, game_board:, change_orders:, spaces_remaining:)
        call(game_board: money_gained_or_lost.(game_board: game_board, money_adjustment: 15),
          board_space: board_space,
          spaces_remaining: spaces_remaining - 1,
          change_orders: change_orders.push(get_money_gained_node.(
            player: game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)},
            money_gained: 15,
            reason: {name: 'by_passing_start'})))
      end

      def handle_spy_alley_entrance(board_space, game_board:, change_orders:, spaces_remaining:)
        process_move_options.(
          game_board: game_board,
          change_orders: change_orders,
          board_space: board_space,
          spaces_remaining: spaces_remaining - 1)
      end

      def handle_buy_password(board_space, game_board:, change_orders:, spaces_remaining:)
        # no special action, go to the next space
        call(game_board: game_board,
          change_orders: change_orders,
          board_space: board_space,
          spaces_remaining: spaces_remaining - 1)
      end
      alias_method :handle_buy_equipment, :handle_buy_password
      alias_method :handle_black_market, :handle_buy_password
      alias_method :handle_border_crossing, :handle_buy_password
      alias_method :handle_confiscate_materials, :handle_buy_password
      alias_method :handle_draw_free_gift, :handle_buy_password
      alias_method :handle_draw_move_card, :handle_buy_password
      alias_method :handle_embassy, :handle_buy_password
      alias_method :handle_move_back, :handle_buy_password
      alias_method :handle_sold_top_secret_information, :handle_buy_password
      alias_method :handle_spy_eliminator, :handle_buy_password
      alias_method :handle_take_another_turn, :handle_buy_password
    end
  end
end

