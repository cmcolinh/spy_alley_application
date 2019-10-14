# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class NoActionResult
      def call(player_model:, change_orders:, action_hash:, target_player_model: nil)
        false
      end
    end
  end
end

