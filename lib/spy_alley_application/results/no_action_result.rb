# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class NoActionResult
      def call(player_model:, change_orders:, action_hash:, opponent_models: nil, decks_model: nil)
        false # the current player's turn will *not* continue
      end
    end
  end
end
