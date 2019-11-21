# frozen_string_literal: true



module SpyAlleyApplication
  module Actions
    class ConfiscateMaterialsAction
      extend Dry::Initializer
      option :confiscation_price, default: ->{
        %w(french german spanish italian american russian).map do |nationality|
          [['password', 15],['codebook', 5],['disguise', 15],['key', 50]].map do |equipment, price|
            ["#{nationality} #{equipment}", price]
          end.to_h
        end.reduce({}, :merge).tap{|h| h['wild card'] = 50}
      }
      def call(player_model:, target_player_models:, change_orders:, action_hash:, decks_model: nil)
        equipment_to_confiscate = action_hash[:equipment_to_confiscate]
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
        change_orders.add_action(action_hash.dup)
        equipment_to_confiscate
      end
    end
  end
end
