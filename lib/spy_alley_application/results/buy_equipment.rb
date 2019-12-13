# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'
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
      extend Dry::Initializer
      option :next_player_up_for, default: -> do
        SpyAlleyApplication::Results::NextPlayerUp::new(
          next_player_options: SpyAlleyApplication::Results::NextPlayerUp::ForgoAddingOptions::new
        )
      end

      def call(player_model:, opponent_models:, change_orders:, action_hash:, purchase_options:, purchase_limit:)
        change_orders = change_orders.add_buy_equipment_option(
          equipment: purchase_options,
          limit: purchase_limit
        )
        next_player_up_for.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          turn_complete?: false # will be same player's turn again
        )
      end
    end
  end
end
