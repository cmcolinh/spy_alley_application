# frozen string literal: true

require 'dry-initializer'
require 'spy_alley_application/types/free_gift'

module SpyAlleyApplication
  module Actions
    class ConfiscateMaterials
      include Dry::Initializer.define -> do
        option :equipment_confiscated, type: ::Types::Callable, reader: :private
        option :get_equipment_gained_node, type: ::Types::Callable, reader: :private
        option :get_wild_card_gained_node, type: ::Types::Callable, reader: :private
        option :process_proceeding_to_next_state, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, target_player_id:, equipment_to_confiscate:)
        player = game_board.current_player
        target_player = game_board.players.find{|p| p.id.eql?(target_player_id)}
        equipment = SpyAlleyApplication::Types::FreeGift.call(equipment_to_confiscate)
        game_board = equipment_confiscated.(
          game_board: game_board,
          target_player: target_player,
          equipment: equipment)
        amount_paid = player.money - game_board.players.find{|p| p.seat.eql?(player.seat)}.money
        change_orders = equipment.accept(self,
          change_orders: change_orders,
          amount_paid: amount_paid,
          player: player,
          target_player: target_player)
        process_proceeding_to_next_state.(
          game_board: game_board,
          change_orders: change_orders)
      end

      def handle_equipment(equipment, change_orders:, amount_paid:, player:, target_player:)
        change_orders.push(get_equipment_gained_node.(
          player_id: player.id,
          equipment: [equipment],
          reason: {
            name: 'by_confiscation',
            target_player_id: target_player.id,
            amount_paid: amount_paid}))
      end

      def handle_wild_card(equipment, change_orders:, amount_paid:, player:, target_player:)
        change_orders.push(get_wild_card_gained_node.(
          player_id: player.id,
          number_gained: 1,
          reason: {
            name: 'by_confiscation',
            target_player_id: target_player.id,
            amount_paid: amount_paid}))
      end
    end
  end
end

