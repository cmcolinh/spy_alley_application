# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class TakeAnotherTurn
      def call(player_model:, change_orders:, action_hash:, opponent_models: nil, decks_model: nil)
        true # will be same player's turn again
      end
    end
  end
end
