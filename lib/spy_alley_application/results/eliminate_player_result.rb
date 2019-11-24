# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class EliminatePlayerResult
      extend Dry::Initializer
      option :transfer_money, default: ->{TransferMoney::new}
      option :transfer_equipment, default: ->{TransferEquipment::new}
      option :transfer_wild_cards, default: ->{TransferWildCards::new}

      def call(player_model:, target_player_model:, change_orders:, return_player:)
        change_orders.eliminate_player_action(
          player: {game: target_player_model.game, seat: target_player_model.seat})
        transfer_money.(from: target_player_model, to: player_model, change_orders: change_orders)
        transfer_equipment.(from: target_player_model, to: player_model, change_orders: change_orders)
        transfer_wild_cards.(from: target_player_model, to: player_model, change_orders: change_orders)
        change_orders.add_choose_new_spy_identity_option(return_player: return_player, options: [
          player_model.seat,
          target_player_model.seat
        ])
      end

      class TransferMoney
        def transfer_money(to:, from:, change_orders:)
          return if from.money.eql? 0
          change_orders.subtract_money_action(
            player: {game: from.game, seat: from.seat},
            amount: from.money,
            paid_to: :"seat_#{to.seat}"
          )
          change_orders.add_money_action(
            player: {game: to.game, seat: to.seat},
            amount: to.money,
            reason: 'eliminating opponent'
          )
        end
        alias_method :call, :transfer_money
      end

      class TransferEquipment
        def transfer_equipment(to:, from:, change_orders:)
          from.equipment.each do |equipment|
            change_orders.subtract_equipment_action(
              player: {game: from.game, seat: from.seat},
              equipment: equipment
            )
          end
          (from.equipment - to.equipment).each do |equipment|
            change_orders.add_equipment_action(
              player: {game: to.game, seat: to.seat},
              equipment: equipment
            )
          end
        end
        alias_method :call, :transfer_equipment
      end

      class TransferWildCards
        def transfer_wild_cards(from:, to:, change_orders:)
          from.wild_cards.times do |wild_card|
            change_orders.subtract_wild_card_action(player: {game: from.game, seat: from.seat})
            change_orders.add_wild_card_action(player: {game: to.game, seat: to.seat})
          end
        end
        alias_method :call, :transfer_wild_cards
      end
    end
  end
end

