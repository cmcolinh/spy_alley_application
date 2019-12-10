# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'

module SpyAlleyApplication
  module Results
    class SpyEliminator
      extend Dry::Initializer
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      def call(player_model:, change_orders:, action_hash: nil, opponent_models:, decks_model: nil)
        opponents_in_spy_alley = opponent_models.select{|p| in_spy_alley(p)}.map(&:seat)
        if !opponents_in_spy_alley.empty?
          change_orders = change_orders.add_spy_eliminator_option(
            options: opponents_in_spy_alley.map{|s| "seat_#{s}"}
          )
        end
        next_player_up_for.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          turn_complete?: opponents_in_spy_alley.empty?
        )
      end

      def in_spy_alley(opponent_player_model)
        opponent_player_model.location.include?('s')
      end
    end
  end
end
