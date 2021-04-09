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

      def call(game_board:, change_orders:, game_space:, spaces_remaining:)
        game_space = game_space.next_space
        if spaces_remaining.eql?(1)
          process_landing_on_space.(
            game_board: game_board,
            change_orders: change_orders
            game_space: game_space)
        else
          game_space.accept(self,
            game_board: game_board,
            change_orders: change_orders,
            spaces_remaining: spaces_remaining)
        end
      end

      def handle_start(game_space, game_board:, change_orders:, spaces_remaining:)
        call(game_board: money_gained_or_lost.(game_board: game_board, money_adjustment: 15),
          game_space: game_space,
          spaces_remaining: spaces_remaining - 1,
          change_orders: change_orders.push(get_money_gained_node.(
            player_id: game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}.id,
            money_gained: 15,
            reason: 'passing_start'))
      end

      def handle_spy_alley_entrance(game_space, game_board:, change_orders:, spaces_remaining:)
        process_move_options.(
          game_board: game_board,
          change_orders: change_orders,
          game_space: game_space,
          spaces_remaining: spaces_remaining)

      def handle_buy_password(game_space, game_board:, change_orders:, spaces_remaining:)
        # no special action, go to the next space
        call(game_board: game_board,
          change_orders: change_orders,
          game_space: game_space,
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

