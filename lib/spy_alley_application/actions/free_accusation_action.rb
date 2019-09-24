# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/eliminate_player_result'

module SpyAlleyApplication
  module Actions
    class FreeAccusationAction
      extend Dry::Initializer
      option :eliminate_player, default: ->{SpyAlleyApplication::Results::EliminatePlayerResult::new}
      
      def call(change_orders:, player_model:, target_player_model:, action_hash:)
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
        end
        guess_correct
      end
    end
  end
end

