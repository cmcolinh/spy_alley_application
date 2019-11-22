# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class MoveBackTwoSpaces
      def call(player_model:, change_orders:, action_hash: nil, opponent_models: nil, decks_model: nil)
        change_orders.add_move_back_two_spaces_result
        false # the current player's turn will *not* continue
      end
    end
  end
end
