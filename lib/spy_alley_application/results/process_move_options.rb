require 'dry-initializer'

module SpyAlleyApplication
  module Results
    class ProcessMoveOptions
      include Dry::Initializer.define -> do
        option :move_options, type: ::Types::Callable, reader: :private
        option :process_landing_on_space, type: ::Types::Callable, reader: :private
        option :process_next_turn_options, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, board_space:, spaces_remaining:)
        space_id_list = [board_space.branch_space, board_space.next_space]
          .map{|space| space_id(space, game_board, spaces_remaining - 1)}
          .reject(&:nil?)
          .freeze

        if space_id_list.length.eql?(1)
          process_landing_on_space.(
            game_board: game_board,
            change_orders: change_orders,
            space_id: space_id_list.first)
        else
          game_board = move_options.(game_board: game_board, options: space_id_list)
          process_next_turn_options.(game_board: game_board, change_orders: change_orders)
        end
      end

      # player cannot land on border crossing if cannot pay the toll ($5) to cross the border
      def handle_border_crossing(space, game_board:)
        if game_board.current_player.money < 5
          nil
        else
          space.id
        end
      end

      # no other such restriction from landing on any other space on the board
      def handle_embassy(space, game_board:)
        space.id
      end
      alias_method :handle_move_back, :handle_embassy
      alias_method :handle_buy_password, :handle_embassy
      alias_method :handle_buy_equipment, :handle_embassy
      alias_method :handle_draw_move_card, :handle_embassy
      alias_method :handle_sold_top_secret_information, :handle_embassy
      alias_method :handle_spy_eliminator, :handle_embassy
      alias_method :handle_confiscate_materials, :handle_embassy
      alias_method :handle_take_another_turn, :handle_embassy
      alias_method :handle_draw_free_gift, :handle_embassy
      alias_method :handle_start, :handle_embassy
      alias_method :handle_black_market, :handle_embassy
      alias_method :handle_spy_alley_entrance, :handle_embassy

      private
      def space_id(space, game_board, spaces_remaining)
        spaces_remaining.times{space = space.next_space}
        space.accept(self, game_board: game_board)
      end
    end
  end
end

