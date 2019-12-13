# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'

module SpyAlleyApplication
  module Results
    class NoActionResult
      extend Dry::Initializer
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      def call(player_model:, opponent_models:, change_orders:, action_hash:, decks_model: nil)
        next_player_up_for.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          turn_complete?: true # the current player's turn will *not* continue
        )
      end
    end
  end
end
