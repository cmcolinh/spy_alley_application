# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'
require 'spy_alley_application/results/embassy/french'
require 'spy_alley_application/results/embassy/german'
require 'spy_alley_application/results/embassy/spanish'
require 'spy_alley_application/results/embassy/italian'
require 'spy_alley_application/results/embassy/american'
require 'spy_alley_application/results/embassy/russian'

module SpyAlleyApplication
  module Results
    class Embassy
      extend Dry::Initializer
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      def call(player_model:, opponent_models:, action_hash:, change_orders:, nationality:)
        turn_complete = true
        if player_model.spy_identity.eql?(nationality) && all_equipment_collected(player_model, nationality)
          change_orders = change_orders.add_game_victory(
            player: {game: player_model.game, seat: player_model.seat},
            reason: 'reached their embassy with a full set of equipment'
          )
          turn_complete = false
        end
        next_player_up_for.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          turn_complete?: turn_complete
        )
      end

      private
      def all_equipment_collected(player_model, nationality)
        (player_model.equipment.filter{|e| e.include? nationality}.count + player_model.wild_cards) >= 4
      end
    end
  end
end
