# frozen string literal: true

require 'dry-initializer'

module SpyAlleyApplication
  module Actions
    class BuyEquipment
      include Dry::Initializer.define -> do
        option :equipment_bought, type: ::Types::Callable, reader: :private
        option :get_equipment_gained_node, type: ::Types::Callable, reader: :private
        option :process_proceeding_to_next_state, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, equipment_to_buy:)
        equipment_to_buy = equipment_to_buy.map{|e| SpyAlleyApplication::Models::Equipment.call(e)}
        player = game_board.current_player
        game_board = equipment_bought.(
          game_board: game_board,
          equipment_bought: equipment_to_buy)
        total_cost = player.money - game_board.players.find{|p| p.seat.eql?(player.seat)}.money
        process_proceeding_to_next_state.(
          game_board: game_board,
          change_orders: change_orders.push(get_equipment_gained_node.(
            player: player,
            equipment: equipment_to_buy,
            reason: {name: 'by_purchase', amount_paid: total_cost})))
      end
    end
  end
end

