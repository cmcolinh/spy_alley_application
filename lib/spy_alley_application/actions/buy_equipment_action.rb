# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Actions
    class BuyEquipmentAction
      extend Dry::Initializer
      option :purchase_price, default: ->{
        %w(french german spanish italian american russian).map do |nationality|
          [['password', 1],['codebook', 5],['disguise', 15],['key', 30]].map do |equipment, price|
            ["#{nationality} #{equipment}", price]
          end.to_h
        end.reduce({}, :merge)
      }
      def call(player_model:, change_orders:, action_hash:, opponent_models: nil, decks_model: nil)
        total_cost = 0
        Array(action_hash[:equipment_to_buy]).each do |equipment|
          equipment = equipment[0] if equipment.is_a?(Array)
          change_orders.add_equipment_action(
            player: {game: player_model.game, seat: player_model.seat},
            equipment: equipment
          )
          total_cost += purchase_price[equipment]
        end
        change_orders.subtract_money_action(
          player: {game: player_model.game, seat: player_model.seat},
          amount:  total_cost,
          paid_to: :bank
        )
        change_orders.add_action(
          action_hash.dup.merge(result: {total_amount_paid: "#{total_cost} to bank"})
        )
        action_hash[:equipment_to_buy]
      end
    end
  end
end
