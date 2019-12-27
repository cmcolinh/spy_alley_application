# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'
require 'spy_alley_application/results/eliminate_player_result'

module SpyAlleyApplication
  module Actions
    class FreeAccusationAction
      extend Dry::Initializer
      option :eliminate_player, default: ->{SpyAlleyApplication::Results::EliminatePlayerResult::new}
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      def call(change_orders:, player_model:, opponent_models:, action_hash:, decks_model: nil)
        target_player_model = get_target_player_model_from(opponent_models, action_hash)
        accusation_targets = action_hash[:accusation_targets]
        guess_correct = action_hash[:nationality].eql?(target_player_model.spy_identity)
        change_orders = change_orders.add_action(action_hash.dup.reject{|k, v| k.eql?(:accusation_targets)})
        return_player = nil
        turn_complete = false
        remaining_choices = accusation_targets - [action_hash[:player_to_accuse]]
        if guess_correct
          change_orders = change_orders.add_action(result: {guess_correct: true})
          change_orders = eliminate_player.(
            player_model:        target_player_model,
            opponent_models:     opponent_models,
            target_player_model: player_model,
            change_orders:       change_orders,
            return_player:       get_next_seat_from(player_model, opponent_models)
          )
          if remaining_choices.size > 0
            return_player = player_model.seat
          else
            return_player = get_next_seat_from(player_model, (opponent_models - [target_player_model]))
          end
          options = {
            player_model:        player_model,
            target_player_model: target_player_model,
            change_orders:       change_orders,
            return_player:       return_player
          }
          options[:remaining_choices] = remaining_choices.map{|s| s.gsub("seat_", "").to_i}
          change_orders = eliminate_player.(options)
        else
          change_orders = change_orders.add_action(result: {guess_correct: false})
          if remaining_choices.size > 0
            change_orders = change_orders.add_spy_eliminator_option(options: remaining_choices)
          else
            turn_complete = true
          end
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

