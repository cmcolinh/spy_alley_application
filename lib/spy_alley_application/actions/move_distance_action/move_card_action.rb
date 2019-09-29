# frozen_string_literal: true

module SpyAlleyApplication
  module Actions
    class MoveDistanceAction
      class MoveCardAction
        def call(player_model:, change_orders:, action_hash:, target_player_model: nil)
          card_to_use = action_hash[:card_to_use]

          change_orders.add_use_move_card(
            player: {game: player_model.game, seat: player_model.seat},
            card_to_use: card_to_use
          )

          card_to_use
        end
      end
    end
  end
end
