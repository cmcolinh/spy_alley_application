# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'

module SpyAlleyApplication
  module Results
    class SpyEliminator
      extend Dry::Initializer
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      option :next_turn_make_accusation, default: -> do
        SpyAlleyApplication::Results::NextPlayerUp::new(
          next_player_options: SpyAlleyApplication::Results::NextPlayerUp::SpyEliminatorOptions::new
        )
      end

      def call(player_model:, change_orders:, action_hash:, opponent_models:, decks_model: nil)
        options = {
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
        }
        opponents_in_spy_alley = opponent_models.select{|p| in_spy_alley(p)}.map(&:seat)
        if !opponents_in_spy_alley.empty?
          action_hash[:accusation_targets] = opponents_in_spy_alley.map{|s| "seat_#{s}"}
          
          #change_orders = change_orders.add_spy_eliminator_option(
            options: opponents_in_spy_alley.map{|s| "seat_#{s}"}
          )
        else
          next_player_up_for.(options.merge(turn_complete?: true))
        end
      end

      def in_spy_alley(opponent_player_model)
        opponent_player_model.location.include?('s')
      end
    end
  end
end
