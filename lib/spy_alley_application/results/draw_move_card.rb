# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class DrawMoveCard
      extend Dry::Initializer
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      def call(player_model:, change_orders:, action_hash:, opponent_models: nil, decks_model:)
        if !decks_model.top_move_card.nil?
          change_orders = change_orders.add_draw_top_move_card(
            player: {game: player_model.game, seat: player_model.seat},
            top_move_card: decks_model.top_move_card
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
