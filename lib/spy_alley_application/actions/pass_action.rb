# frozen_string_literal: true

module SpyAlleyApplication
  module Actions
    class PassAction
      def call(change_orders:, player_model:, opponent_models: nil, action_hash:, decks_model: nil)
        change_orders.add_pass_action
      end
    end
  end
end
