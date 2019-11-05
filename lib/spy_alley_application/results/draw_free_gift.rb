# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class DrawFreeGift
      extend Dry::Initializer
      def call(player_model:, change_orders:, action_hash:, target_player_model: nil, decks_model:)
        free_gift_card = change_orders.add_draw_top_free_gift_card(
          player: {game: player_model.game, seat: player_model.seat},
          top_free_gift_card: decks_model.top_free_gift_card
        )
        if top_free_gift_card.eql?('wild card')
          change_orders.add_wild_card_action(player: {game: player_model.game, seat: player_model.seat})
        else
          change_orders.place_card_at_bottom_of_free_gift_deck(free_gift_card)
          if !player_model.equipment.include?(free_gift_card)
            change_orders.add_equipment_action(
              player: {game: player_model.game, seat: player_model.seat},
              equipment: free_gift_card
            )
          end
        end
        false # the current player's turn will *not* continue
      end
    end
  end
end
