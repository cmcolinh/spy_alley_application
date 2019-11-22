# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class BuyEquipment
      class AmericanPassword
        extend Dry::Initializer
        option :do_nothing, default: ->{SpyAlleyApplication::Results::NoActionResult::new}
        option :buy_equipment, default: ->{SpyAlleyApplication::Results::BuyEquipment::new}
        def call(player_model:, change_orders:, action_hash:, opponent_models: nil, decks_model: nil)
          if player_model.equipment.include?('american password') || player_model.money < 1
            do_nothing.(
              player_model: player_model,
              change_orders: change_orders,
              action_hash: action_hash
            )
          else
            buy_equipment.(
              change_orders: change_orders,
              purchase_options: ['american password'],
              purchase_limit: 1
            )
          end
        end
      end
    end
  end
end
