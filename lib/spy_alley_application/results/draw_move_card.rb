# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Results
    class DrawMoveCard
      extend Dry::Initializer
      def call(player_model:, change_orders:, action_hash:, opponent_models: nil, decks_model:)
        if !decks_model.top_move_card.nil?
          change_orders = change_orders.add_draw_top_move_card(
            player: {game: player_model.game, seat: player_model.seat},
            top_move_card: decks_model.top_move_card
          )
        end
        false # the current player's turn will *not* continue
        change_orders
      end
    end
  end
end
