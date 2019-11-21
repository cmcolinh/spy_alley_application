# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/eliminate_player_result'

module SpyAlleyApplication
  module Actions
    class AtRiskAccusationAction
      extend Dry::Initializer
      option :eliminate_player, default: ->{SpyAlleyApplication::Results::EliminatePlayerResult::new}
      def call(player_model:, target_player_models:, change_orders:, action_hash:, decks_model: nil)
        target_player_model = get_target_player_model_from(target_player_models, action_hash)
        guess_correct = action_hash[:nationality].eql?(target_player_model.spy_identity)
        change_orders.add_action(action_hash.dup)
        if guess_correct
          change_orders.add_action(result: {guess_correct: true})
          eliminate_player.(
            player_model:        player_model,
            target_player_model: target_player_model,
            change_orders:       change_orders
          )
        else
          change_orders.add_action(result: {guess_correct: false})
          eliminate_player.(
            player_model:        target_player_model,
            target_player_model: player_model,
            change_orders:       change_orders
          )
        end
        return guess_correct
      end

      def get_target_player_model_from(target_player_models, action_hash)
        seat = action_hash[:seat].gsub('seat_', '').to_i
        target_player_models.select{|m| m.seat = seat}.first
      end
    end
  end
end

