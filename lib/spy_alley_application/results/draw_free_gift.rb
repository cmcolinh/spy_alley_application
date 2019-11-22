# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class DrawFreeGift
      extend Dry::Initializer
      def call(player_model:, change_orders:, action_hash:, opponent_models: nil, decks_model:)
        free_gift_card = decks_model.top_free_gift_card
        change_orders.add_draw_top_free_gift_card(
          player: {game: player_model.game, seat: player_model.seat},
          top_free_gift_card: free_gift_card
        )
        if !free_gift_card.eql?('wild card') && !player_model.equipment.include?(free_gift_card)
          change_orders.add_equipment_action(
            player: {game: player_model.game, seat: player_model.seat},
            equipment: free_gift_card
          )
        end
        false # the current player's turn will *not* continue
      end
    end
  end
end
