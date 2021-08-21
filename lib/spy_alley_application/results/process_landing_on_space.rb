# require 'dry-initializer'

module SpyAlleyApplication
  module Results
    class ProcessLandingOnSpace
      include Dry::Initializer.define -> do
        option :black_market_option_state, type: ::Types::Callable, reader: :private
        option :buy_equipment_option_state, type: ::Types::Callable, reader: :private
        option :buy_password_option_state, type: ::Types::Callable, reader: :private
        option :confiscate_materials_option_state, type: ::Types::Callable, reader: :private
        option :embassy_victory, type: ::Types::Callable, reader: :private
        option :free_gift_drawn, type: ::Types::Callable, reader: :private
        option :get_equipment_gained_node, type: ::Types::Callable, reader: :private
        option :get_game_over_node, type: ::Types::Callable, reader: :private
        option :get_money_gained_node, type: ::Types::Callable, reader: :private
        option :get_money_lost_node, type: ::Types::Callable, reader: :private
        option :get_move_card_drawn_node, type: ::Types::Callable, reader: :private
        option :get_player_movement_node, type: ::Types::Callable, reader: :private
        option :get_result_game_board_node, type: ::Types::Callable, reader: :private
        option :get_wild_card_gained_node, type: ::Types::Callable, reader: :private
        option :money_gained_or_lost, type: ::Types::Callable, reader: :private
        option :move_card_drawn, type: ::Types::Callable, reader: :private
        option :next_game_state, type: ::Types::Callable, reader: :private
        option :player_moved, type: ::Types::Callable, reader: :private
        option :process_next_turn_options, type: ::Types::Callable, reader: :private
        option :process_proceeding_to_next_state, type: ::Types::Callable, reader: :private
        option :spy_eliminator_options, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, space_id:)
        player = game_board.current_player
        change_orders = change_orders.push(get_player_movement_node.(
          player_id: player.id,
          space_id: space_id))
        game_board = player_moved.(game_board: game_board, new_location: {id: space_id})
        board_space = game_board.current_player.location
        board_space.accept(self, game_board: game_board, change_orders: change_orders)
      end

      # ///////////////

      def handle_black_market(board_space, game_board:, change_orders:)
        game_board = black_market_option_state.(game_board: game_board)
        process_next_turn_options.(
          game_board: game_board,
          change_orders: change_orders.push(get_result_game_board_node.(game_board: game_board)))
      end

      # ///////////////

      def handle_border_crossing(board_space, game_board:, change_orders:)
        change_orders = change_orders.push(get_money_lost_node.(
          player_id: game_board.current_player.id,
          money_lost: 5))
        game_board = money_gained_or_lost.(
          game_board: game_board,
          money_adjustment: -5)
        process_proceeding_to_next_state.(
          game_board: game_board,
          change_orders: change_orders)
      end

      # ///////////////

      def handle_buy_equipment(board_space, game_board:, change_orders:)
        game_board = buy_equipment_option_state.(
          game_board: game_board,
          equipment_type: board_space.equipment_type)
        process_next_turn_options.(
          game_board: game_board,
          change_orders: change_orders.push(get_result_game_board_node.(game_board: game_board)))
      end

      # ///////////////

      def handle_buy_password(board_space, game_board:, change_orders:)
        game_board = buy_password_option_state.(
          game_board: game_board,
          nationality: board_space.nationality)
        process_next_turn_options.(
          game_board: game_board,
          change_orders: change_orders.push(get_result_game_board_node.(game_board: game_board)))
      end

      # ///////////////

      def handle_confiscate_materials(board_space, game_board:, change_orders:)
        game_board = confiscate_materials_option_state.(game_board: game_board)
        process_next_turn_options.(
          game_board: game_board,
          change_orders: change_orders.push(get_result_game_board_node.(game_board: game_board)))
      end

      # ///////////////

      def handle_draw_free_gift(board_space, game_board:, change_orders:)
        change_orders = game_board.free_gift_pile.first.accept(self,
          change_orders: change_orders,
          player: game_board.current_player)
        game_board = free_gift_drawn.(game_board: game_board)
        process_proceeding_to_next_state.(
          game_board: game_board,
          change_orders: change_orders)
      end

      def handle_equipment(equipment, change_orders:, player:)
        change_orders.push(get_equipment_gained_node.(
          player: player,
          equipment: [equipment],
          reason: {name: 'by_free_gift'}))
      end

      def handle_wild_card(wild_card, change_orders:, player:)
        change_orders.push(get_wild_card_gained_node.(
          player: player,
          number_gained: 1,
          reason: {name: 'by_free_gift'}))
      end

      # ///////////////

      def handle_draw_move_card(board_space, game_board:, change_orders:)
        change_orders = change_orders.push(get_move_card_drawn_node.(
          player_id: game_board.current_player.id,
          card: game_board.move_card_pile.first.value))
        game_board = move_card_drawn.(game_board: game_board)
        process_proceeding_to_next_state.(
          game_board: game_board,
          change_orders: change_orders)
      end

      # ///////////////

      def handle_embassy(board_space, game_board:, change_orders:)
        player = game_board.current_player
        spy_identity = player.spy_identity
        equipment_total = player.equipment.select{|e| e.nationality.eql?(spy_identity)}.size
        equipment_total += player.wild_cards
        if equipment_total >= 4
          change_orders
            .push(get_game_over_node.(winning_player_id: player.id, reason: {name: 'by_embassy'}))
            .push(get_result_game_board_node.(
              game_board: embassy_victory.(game_board: game_board)))
        else
          process_proceeding_to_next_state.(
            game_board: game_board,
            change_orders: change_orders)
        end
      end

      # ///////////////

      def handle_move_back(board_space, game_board:, change_orders:)
        game_board = game_board = player_moved.(
          game_board: game_board,
          new_location: board_space.move_back_space)
        change_orders = change_orders.push(get_player_movement_node.(
          player_id: game_board.current_player.id,
          space_id: board_space.move_back_space.id))
        game_board = game_board = player_moved.(game_board: game_board, new_location: board_space)
        process_proceeding_to_next_state.(
          game_board: game_board,
          change_orders: change_orders)
      end

      # ///////////////

      def handle_sold_top_secret_information(board_space, game_board:, change_orders:)
        current_player = game_board.current_player

        game_board = money_gained_or_lost.(
          game_board: game_board,
          money_adjustment: board_space.money_gained)

        process_proceeding_to_next-state.(
          game_board: game_board,
          change_orders: change_orders
            .push(get_money_gained_node.(
              player_id: current_player.id,
              money_gained: board_space.money_gained,
              reason: {name: 'by_selling_top_secret_information'})))
      end

      # ///////////////

      def handle_spy_alley_entrance(board_space, game_board:, change_orders:)
        process_proceeding_to_next_state.(
          game_board: game_board,
          change_orders: change_orders)
      end

      # ///////////////

      def handle_spy_eliminator(board_space, game_board:, change_orders:)
        game_board = spy_eliminator_options.(game_board: game_board)

        process_next_turn_options.(
          game_board: next_game_state.(game_board: game_board),
          change_orders: change_orders.push(get_result_game_board_node.(game_board: game_board)))
      end

      # ///////////////

      def handle_start(board_space, game_board:, change_orders:)
        current_player = game_board.current_player

        game_board = money_gained_or_lost.(
          game_board: game_board,
          money_adjustment: 15,
          &next_game_state)

        process_next_turn_options.(
          game_board: game_board,
          change_orders: change_orders
            .push(get_money_gained_node.(
              player_id: current_player.id,
              money_gained: 15,
              reason: {name: 'by_passing_start'}))
            .push(get_result_game_board_node.(game_board: game_board)))
      end

      # ///////////////

      def handle_take_another_turn(board_space, game_board:, change_orders:)
        process_next_turn_options.(
          game_board: game_board,
          change_orders: change_orders.push(get_result_game_board_node.(game_board: game_board)))
      end
    end
  end
end

