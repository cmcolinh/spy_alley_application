# frozen_string_literal: true

require 'dry-initializer'
require 'spy_alley_application/models/game_state/buy_equipment'

module SpyAlleyApplication
  module Results
    class ProcessBuyEquipmentOptions
      include Dry::Initializer.define -> do
        option :get_buy_equipment_option_node, type: ::Types::Callable, reader: :private
        option :get_next_player_node, type: ::Types::Callable, reader: :private
        option :get_pass_option_node, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:)
        next_player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
        node = SpyAlleyApplication::Models::GameState::BuyEquipment.call(game_board.game_state)
        change_orders.push(get_next_player_node.(player: next_player))
          .push(get_buy_equipment_node.(options: node.options, limit: node.limit))
          .push(get_pass_option_node.())
      end
    end
  end
end

