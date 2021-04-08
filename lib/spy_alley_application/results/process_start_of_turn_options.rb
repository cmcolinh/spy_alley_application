# frozen_string_literal: true

require 'dry-initializer'

module SpyAlleyApplication
  module Results
    class ProcessStartOfTurnOptions
      include Dry::Initializer.define -> do
        option :get_make_accusation_option_node, type: ::Types::Callable, reader: :private
        option :get_next_player_node, type: ::Types::Callable, reader: :private
        option :get_roll_die_option_node, type: ::Types::Callable, reader: :private
        option :get_use_move_card_option_node, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:)
        next_player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
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

