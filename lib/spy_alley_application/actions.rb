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

    def buy_equipment(player_model:, change_orders:, equipment_to_buy:)
      total_cost = 0
      Array(equipment_to_buy).each do |equipment|
        equipment = equipment[0] if equipment.is_a?(Array)
        change_orders.add_equipment_action(
          player: {game: player_model.game, seat: player_model.seat},
          equipment: equipment
        )
        total_cost += purchase_price[equipment]
      end
      change_orders.subtract_money_action(
        player: {game: player_model.game, seat: player_model.seat},
        amount:  total_cost,
        paid_to: :bank
      )
      change_orders.add_action(
        player_action: 'buy_equipment',
        equipment_to_buy: equipment_to_buy,
        result: {total_amount_paid: "#{total_cost} to bank"}
      )
      equipment_to_buy
    end

    def confiscate_materials(player_model:, change_orders:, target_player_model:, equipment_to_confiscate:)
      price = confiscation_price[equipment_to_confiscate]
      if equipment_to_confiscate.eql? 'wild card'
        change_orders.add_wild_card_action(
          player: {game: player_model.game, seat: player_model.seat}
        )
        change_orders.subtract_wild_card_action(
          player: {game: target_player_model.game, seat: target_player_model.seat}
        )
      else
        change_orders.add_equipment_action(
          player: {game: player_model.game, seat: player_model.seat},
          equipment: equipment_to_confiscate
        )
        change_orders.subtract_equipment_action(
          player: {game: target_player_model.game, seat: target_player_model.seat},
          equipment: equipment_to_confiscate
        )
      end
      change_orders.subtract_money_action(
        player: {game: player_model.game, seat: player_model.seat},
        amount:  price,
        paid_to: :"seat_#{target_player_model.seat}"
      )
      change_orders.add_money_action(
        player: {game: target_player_model.game, seat: target_player_model.seat},
        amount: price,
        reason: 'equipment confiscated'
      )
      change_orders.add_action(
        player_action:             'confiscate_materials',
        player_to_confiscate_from: target_player_model.seat,
        equipment_to_confiscate:   equipment_to_confiscate
      )
      equipment_to_confiscate
    end

    def choose_spy_identity(player_model:, change_orders:, identity_chosen:)
      change_orders.choose_new_spy_identity_action(
        player: {game: player_model.game, seat: player_model.seat},
        identity_chosen: identity_chosen
      )
      identity_chosen
    end
  end
end
