# frozen string literal: true

require 'dry-initializer'

module SpyAlleyApplication
  module Actions
    class ChooseNewSpyIdentity
      include Dry::Initializer.define -> do
        option :get_new_spy_identity_chosen_node, type: ::Types::Callable, reader: :private
        option :get_result_game_board_node, type: ::Types::Callable, reader: :private
        option :new_spy_identity_chosen, type: ::Types::Callable, reader: :private
        option :process_proceeding_to_next_state, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, nationality:)
        change_orders = change_orders.push(get_new_spy_identity_chosen_node.(
          nationality: nationality))
        game_board = new_spy_identity_chosen.(
          game_board: game_board,
          new_spy_identity: nationality)
        process_proceeding_to_next_state.(game_board: game_board, change_orders: change_orders)
      end
    end
  end
end

