module SpyAlleyApplication
  module Results
    def move_options(player_model:, change_orders:, distance:)
      space = move_options_from(
        location_id: player_model.location_id,
        distance:    distance,
        money:       player_model.money
      )

      if Array(space).length > 1
        change_orders.add_move_options(options: space)
      else
        action_for(space).(player_model: player_model, change_orders: change_orders)
      end
    end

    def draw_move_card(player_model:, change_orders:)
      move_card_deck_model = data_store.get_move_card_deck_model
      card_drawn           = move_card_deck_model.top_card

      change_orders.draw_top_move_card
      change_orders.add_move_card(
        player:      {game: player_model.game, seat: player_model.seat},
        card_to_add: card_drawn
      )
    end

    def move_options_from(location_id:, distance:, money:)
      if location_id < 14
        if location_id + distance > 14
          if (location_id + distance).eql?(15)
            #in most cases you get a choice, but in this case you can't go to space 15 with < 5 money
            return ['1s'] if current_resources.money < 5
          end
          #formula for the two options you will have
          return ["#{location_id + distance}", "#{location_id + distance - 14}s"]
        else
          return ["#{location_id + distance}"]
        end
      elsif location_id.eql?(14)
        return ["#{location_id + distance - 14}s"]
      elsif location_id > 14 && location_id < 24
        return ["#{(location_id + distance) % 24}"]
      else
        if location_id + distance > 32
      return ["#{(location_id + distance - 11) % 24}"]
        else
      return ["#{(location_id + distance - 23)}s"]
        end
      end
    end

    def eliminate_player(player_model:, change_orders:, target_player_model:)
      change_orders.eliminate_player_action(
        player: {game: target_player_model.game, seat: target_player_model.seat}
      )
      change_orders.add_money_action(
        player: {game: player_model.game, seat: player_model.seat},
        amount: target_player_model.money,
        reason: 'eliminating opponent'
      )
      (1..target_player_model.wild_cards).each do |wild_card|
        change_orders.add_wild_card_action(
          player: {game: target_player_model.game, seat: target_player_model.seat}
        )
      end

      target_player_model.equipment.each do |equipment|
        if !player_model.equipment.include?(equipment)
          change_orders.add_equipment_action(
            player: {game: player_model.game, seat: player_model.seat},
            equipment: equipment
          )
        end
      end
    end
  end
end

