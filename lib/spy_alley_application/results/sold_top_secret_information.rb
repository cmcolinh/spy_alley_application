# frozen_string_literal: true

require 'spy_alley_application/results/sold_top_secret_information/ten'
require 'spy_alley_application/results/sold_top_secret_information/twenty'

module SpyAlleyApplication
  module Results
    class SoldTopSecretInformation
      def call(player_model:, change_orders:, money_earned:)
        change_orders.add_money_action(
          player: {game: player_model.game, seat: player_model.seat},
          amount: money_earned,
          reason: 'for selling top secret information'
        )
        false # the current player's turn will *not* continue
      end
    end
  end
end
