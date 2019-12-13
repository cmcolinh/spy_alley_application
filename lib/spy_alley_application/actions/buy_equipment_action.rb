# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'

module SpyAlleyApplication
  module Actions
    class BuyEquipmentAction
      extend Dry::Initializer
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      option :purchase_price, default: ->{
        %w(french german spanish italian american russian).map do |nationality|
          [['password', 1],['codebook', 5],['disguise', 15],['key', 30]].map do |equipment, price|
            ["#{nationality} #{equipment}", price]
          end.to_h
        end.reduce({}, :merge)
      }
      def call(player_model:, opponent_models:, change_orders:, action_hash:, decks_model: nil)
        total_cost = 0
        Array(action_hash[:equipment_to_buy]).each do |equipment|
          equipment = equipment[0] if equipment.is_a?(Array)
          change_orders = change_orders.add_equipment_action(
            player: {game: player_model.game, seat: player_model.seat},
            equipment: equipment
          )
          total_cost += purchase_price[equipment]
        end
        change_orders = change_orders.subtract_money_action(
          player: {game: player_model.game, seat: player_model.seat},
          amount:  total_cost,
          paid_to: :bank
        ).add_action(result: {total_amount_paid: "#{total_cost} to bank"})
        next_player_up_for.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders.add_pass_action,
          action_hash: action_hash,
          turn_complete?: true # the current player's turn will *not* continue
        )
      end
    end
  end
end
