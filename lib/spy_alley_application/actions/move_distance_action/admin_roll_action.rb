# frozen_string_literal: true

module SpyAlleyApplication
  module Actions
    class MoveDistanceAction
      class AdminRollAction
        def call(player_model:, change_orders:, action_hash:)
          result_chosen = action_hash[:choose_result]
          [
            change_orders.add_admin_die_roll(
              player: {game: player_model.game, seat: player_model.seat},
              result_chosen: result_chosen
            ),
            result_chosen
          ]
        end
      end
    end
  end
end
