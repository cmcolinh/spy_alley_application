# frozen_string_literal: true

module SpyAlleyApplication
  module Actions
    class ChooseIdentityAction
      def call(player_model:, change_orders:, action_hash:, target_player_model: nil, decks_model: nil)
        identity_chosen = action_hash[:nationality]
        change_orders.choose_new_spy_identity_action(
          player: {game: player_model.game, seat: player_model.seat},
          identity_chosen: identity_chosen
        )
        identity_chosen
      end
    end
  end
end
