# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'

module SpyAlleyApplication
  module Results
    class BorderCrossing
      extend Dry::Initializer
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      def call(player_model:, opponent_models:, change_orders:, action_hash: nil, decks_model: nil)
        change_orders = change_orders.subtract_money_action(
          player: {game: player_model.game, seat: player_model.seat},
          amount: 5,
          paid_to: :bank
        )
        next_player_up_for.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          turn_complete?: true #player's turn is complete
        )
      end
    end
  end
end
