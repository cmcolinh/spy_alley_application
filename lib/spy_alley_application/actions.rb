module SpyAlleyApplication
  module Actions
    def roll(player_model:, change_orders:, roll_die:)
      die_roll = roll_die.()

      change_orders.add_die_roll(
        player: {game: player_model.game, seat: player_model.seat},
        rolled: die_roll
      )

      die_roll
    end

    def use_move_card(player_model:, change_orders:, card_to_use:)
      change_orders.add_use_move_card(
        player: {game: player_model.game, seat: player_model.seat},
        card_to_use: card_to_use
      )

      card_to_use
    end
  end
end
