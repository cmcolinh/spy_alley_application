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

    def move(player_model:, change_orders:, space_to_move:)
      money_per_lap = 15

      change_orders.add_move_action(
        player: {game: player_model.game, seat: player_model.seat},
        space: space_to_move
      )

      if finished_lap(player_model.location, space_to_move)
        change_orders.add_money_action(
          player: {game: player_model.game, seat: player_model.seat},
          amount: money_per_lap,
          reason: 'passing start'
        )
      end

      space_to_move
    end
  end
end
