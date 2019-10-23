# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class BuyEquipment
      class Keys
        extend Dry::Initializer
        @@all_keys = %w(french german spanish italian american russian).map{|n| "#{n} key"}
        option :do_nothing, default: ->{SpyAlleyApplication::Results::NoActionResult::new}
        option :buy_equipment, default: ->{SpyAlleyApplication::Results::BuyEquipment::new}
        def call(player_model:, change_orders:, action_hash:, target_player_model: nil)
          if (@@all_keys - player_model.equipment).empty? || player_model.money < 30
            do_nothing.(
              player_model: player_model,
              change_orders: change_orders,
              action_hash: action_hash
            )
          else
            buy_equipment.(
              change_orders: change_orders,
              purchase_options: @@all_keys - player_model.equipment,
              purchase_limit: [player_model.money / 30, (@@all_keys - player_model.equipment).length].max
            )
          end
        end
      end
    end
  end
end
