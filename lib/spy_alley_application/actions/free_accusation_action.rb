# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'
require 'spy_alley_application/results/eliminate_player_result'

module SpyAlleyApplication
  module Actions
    class FreeAccusationAction
      extend Dry::Initializer
      option :eliminate_player, default: ->{SpyAlleyApplication::Results::EliminatePlayerResult::new}

      def call(change_orders:, player_model:, opponent_models:, action_hash:, decks_model: nil)
        target_player_model = get_target_player_model_from(opponent_models, action_hash)
        guess_correct = action_hash[:nationality].eql?(target_player_model.spy_identity)
        change_orders = change_orders.add_action(action_hash.dup)

        if guess_correct
          change_orders = change_orders.add_action(result: {guess_correct: true})
          change_orders = eliminate_player.(
            player_model:        player_model,
            target_player_model: target_player_model,
            change_orders:       change_orders
          )
        else
          change_orders = change_orders.add_action(result: {guess_correct: false})
        end
        change_orders
      end

      def get_target_player_model_from(opponent_models, action_hash)
        seat = action_hash[:player_to_accuse].gsub('seat_', '').to_i
        opponent_models.select{|m| m.seat.eql? seat}.first
      end
    end
  end
end

