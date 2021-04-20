# require 'dry-initializer'

module SpyAlleyApplication
  module Results
    class ProcessProceedingToNextState
      include Dry::Initializer.define -> do
        option :get_result_game_board_node, type: ::Types::Callable, reader: :private
        option :next_game_state, type: ::Types::Callable, reader: :private
        option :process_next_turn_options, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, target_player_id: nil, **args)
        game_board = next_game_state.(
          game_board: game_board,
          target_player_id: target_player_id)
        process_next_turn_options.(
          game_board: game_board,
          change_orders: change_orders.push(get_result_game_board_node.(game_board: game_board)))
      end
    end
  end
end

