# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/eliminate_player_result'

module SpyAlleyApplication
  module Actions
    class AtRiskAccusationAction
      extend Dry::Initializer
      option :eliminate_player, default: ->{SpyAlleyApplication::Results::EliminatePlayerResult::new}
      def call(player_model:, opponent_models:, change_orders:, action_hash:, decks_model: nil)
        target_player_model = get_target_player_model_from(opponent_models, action_hash)
        guess_correct = action_hash[:nationality].eql?(target_player_model.spy_identity)
        change_orders = change_orders.add_action(action_hash.dup)
        if guess_correct
          change_orders = change_orders.add_action(result: {guess_correct: true})
          change_order = eliminate_player.(
            player_model:        player_model,
            opponent_models:     opponent_models,
            target_player_model: target_player_model,
            change_orders:       change_orders,
            return_player:       get_next_seat_from(player_model, (opponent_models - [target_player_model]))
          )
        else
          change_orders = change_orders.add_action(result: {guess_correct: false})
          change_orders = eliminate_player.(
            player_model:        target_player_model,
            opponent_models:     opponent_models,
            target_player_model: player_model,
            change_orders:       change_orders,
            return_player:       get_next_seat_from(player_model, opponent_models)
          )
        end
        change_orders
      end

      private
      def get_target_player_model_from(opponent_models, action_hash)
        seat = action_hash[:player_to_accuse].gsub('seat_', '').to_i
        opponent_models.select{|m| m.seat.eql? seat}.first
      end

      def get_next_seat_from(player_model, opponent_models)
        opponent_seats = opponent_models.map(&:seat)
        opponent_seats.select{|seat| seat > player_model.seat}.min || opponent_seats.min
      end
    end
  end
end
