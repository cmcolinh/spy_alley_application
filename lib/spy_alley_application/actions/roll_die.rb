# frozen string literal: true

require 'dry-initializer'

module SpyAlleyApplication
  module Actions
    class RollDie
      include Dry::Initializer.define -> do
        option :execute_die_roll, type: ::Types::Callable, reader: :private
        option :get_die_rolled_node, type: ::Types::Callable, reader: :private
        option :process_passing_spaces, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, number_rolled: nil)
        number_rolled ||= execute_die_roll.()
        process_passing_spaces.(
          game_board: game_board,
          change_orders: change_orders.push(get_die_rolled_node.(number_rolled: number_rolled)),
          board_space: game_board.current_player.location,
          spaces_remaining: number_rolled)
      end
    end
  end
end

