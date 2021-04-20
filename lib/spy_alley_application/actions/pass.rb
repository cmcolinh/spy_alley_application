# frozen string literal: true

require 'dry-initializer'

module SpyAlleyApplication
  module Actions
    class Pass
      include Dry::Initializer.define -> do
        option :get_player_passed_node, type: ::Types::Callable, reader: :private
        option :process_proceeding_to_next_state, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:)
        process_proceeding_to_next_state.(
          game_board: game_board,
          change_orders: change_orders.push(get_player_passed_node.()))
      end
    end
  end
end

