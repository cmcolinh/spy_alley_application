# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class BuyEquipment
      class FrenchPassword
        extend Dry::Initializer
        option :do_nothing, default: ->{SpyAlleyApplication::Results::NoActionResult::new}
        option :buy_equipment, default: ->{SpyAlleyApplication::Results::BuyEquipment::new}
        def call(player_model:, change_orders:, action_hash:, opponent_models: nil, decks_model: nil)
          if player_model.equipment.include?('french password') || player_model.money < 1
            do_nothing.(
              player_model: player_model,
              opponent_models: opponent_models,
              change_orders: change_orders,
            )
          else
            buy_equipment.(
              player_model: player_model,
              opponent_models: opponent_models,
              change_orders: change_orders,
              purchase_options: ['french password'],
              purchase_limit: 1
            )
          end
        end
      end
    end
  end
end
