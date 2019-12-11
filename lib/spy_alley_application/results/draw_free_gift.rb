# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'

module SpyAlleyApplication
  module Results
    class DrawFreeGift
      extend Dry::Initializer
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      def call(player_model:, opponent_models:, change_orders:, action_hash:, decks_model:)
        free_gift_card = decks_model.top_free_gift_card
        change_orders = change_orders.add_draw_top_free_gift_card(
          player: {game: player_model.game, seat: player_model.seat},
          top_free_gift_card: free_gift_card
        )
        if !free_gift_card.eql?('wild card') && !player_model.equipment.include?(free_gift_card)
          change_orders = change_orders.add_equipment_action(
            player: {game: player_model.game, seat: player_model.seat},
            equipment: free_gift_card
          )
        end
        next_player_up_for.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          turn_complete?: true # the current player's turn will *not* continue
        )
      end
    end
  end
end
