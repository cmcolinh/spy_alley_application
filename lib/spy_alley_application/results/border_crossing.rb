# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class BorderCrossing
      def call(player_model:, change_orders:, action_hash: nil, opponent_models: nil, decks_model: nil)
        change_orders.subtract_money_action(
          player: {game: player_model.game, seat: player_model.seat},
          amount: 5,
          paid_to: :bank
        )
        false # the current player's turn will *not* continue
      end
    end
  end
end
