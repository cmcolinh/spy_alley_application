# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/buy_equipment/french_password'
require 'spy_alley_application/results/buy_equipment/german_password'
require 'spy_alley_application/results/buy_equipment/spanish_password'
require 'spy_alley_application/results/buy_equipment/italian_password'
require 'spy_alley_application/results/buy_equipment/american_password'
require 'spy_alley_application/results/buy_equipment/russian_password'
require 'spy_alley_application/results/buy_equipment/disguises'
require 'spy_alley_application/results/buy_equipment/codebooks'
require 'spy_alley_application/results/buy_equipment/keys'
require 'spy_alley_application/results/buy_equipment/black_market'

module SpyAlleyApplication
  module Results
    class BuyEquipment
      extends Dry::Initializer
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      def call(change_orders:, purchase_options:, purchase_limit:)
        change_orders = change_orders.add_buy_equipment_option(
          equipment: purchase_options,
          limit: purchase_limit
        )
        next_player_up_for.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          turn_complete?: false # will be same player's turn again
        )
      end
    end
  end
end
