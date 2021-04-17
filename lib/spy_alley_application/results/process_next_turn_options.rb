# frozen_string_literal: true

require 'dry-initializer'

module SpyAlleyApplication
  module Results
    class ProcessNextTurnOptions
      include Dry::Initializer.define -> do
        option :get_buy_equipment_option_node, type: ::Types::Callable, reader: :private
        option :get_confiscate_materials_option_node, type: ::Types::Callable, reader: :private
        option :get_make_accusation_option_node, type: ::Types::Callable, reader: :private
        option :get_move_option_node, type: ::Types::Callable, reader: :private
        option :get_next_player_node, type: ::Types::Callable, reader: :private
        option :get_pass_option_node, type: ::Types::Callable, reader: :private
        option :get_roll_die_option_node, type: ::Types::Callable, reader: :private
        option :get_use_move_card_option_node, type: ::Types::Callable, reader: :private
      end
      def call(game_board:, change_orders:)
        game_board.game_state.accept(self, game_board: game_board, change_orders: change_orders)
      end

      def handle_buy_equipment(game_state, game_board:, change_orders:)
        next_player = game_board.current_player
        change_orders.push(get_next_player_node.(player_id: next_player.id))
          .push(get_buy_equipment_option_node.(
            options: game_state.options,
            limit: game_state.limit))
          .push(get_pass_option_node.())
      end

      def handle_choose_new_spy_identity(game_state, game_board:, change_orders:)
      end

      def handle_confiscate_materials(game_state, game_board:, change_orders:)
        next_player = game_board.current_player
        game_state.targets.each do |t|
          change_orders = change_orders.push(get_confiscate_materials_option_node.(
            target_player_id: game_board.players.find{|p| p.seat.eql?(t.seat)}.id,
            targetable_equipment: t.equipment))
        end
        change_orders.push(get_pass_option_node.())
      end

      def handle_game_over(game_state, game_board:, change_orders:)
      end

      def handle_move_option(game_state, game_board:, change_orders:)
        next_player = game_board.current_player
        change_orders.push(get_next_player_node.(player_id: next_player.id))
          .push(get_move_option_node.(options: game_state.options))
      end

      def handle_spy_eliminator(game_state, game_board:, change_orders:)
        next_player = game_board.current_player
        target_ids = game_board.players
          .select{|p| game_state.targetable_seats.include?(p.seat)}
          .map(&:id)
          .sort
        change_orders.push(get_next_player_node.(player_id: next_player.id))
          .push(get_make_accusation_option_node.(player_id_list: target_ids))
          .push(get_pass_option_node.())
      end

      def handle_start_of_turn(game_state, game_board:, change_orders:)
        next_player = game_board.current_player
        move_cards = next_player.move_cards.map(&:value).sort.uniq
        target_ids = game_board.players.reject{|p| p.id.eql?(next_player.id)}.map(&:id).sort

        change_orders = change_orders.push(get_next_player_node.(player_id: next_player.id))
          .push(get_roll_die_option_node.())
          .push(get_make_accusation_option_node.(player_id_list: target_ids))

        if !move_cards.empty?
          change_orders = change_orders.push(get_use_move_option_node.(card_list: move_cards))
        end

        change_orders
      end
    end
  end
end

