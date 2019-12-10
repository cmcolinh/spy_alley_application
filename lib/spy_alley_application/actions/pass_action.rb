# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'

module SpyAlleyApplication
  module Actions
    class PassAction
      extend Dry::Initializer
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      def call(change_orders:, player_model:, opponent_models: nil, action_hash:, decks_model: nil)
        next_player_up_for.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders.add_pass_action,
          turn_complete?: true # the current player's turn will *not* continue
        )
      end
    end
  end
end
