# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/next_player_up'
require 'spy_alley_application/results/sold_top_secret_information/ten'
require 'spy_alley_application/results/sold_top_secret_information/twenty'

module SpyAlleyApplication
  module Results
    class SoldTopSecretInformation
      extend Dry::Initializer
      option :next_player_up_for, default: ->{SpyAlleyApplication::Results::NextPlayerUp::new}
      def call(player_model:, opponent_models:, change_orders:, money_earned:)
        change_orders.add_money_action(
          player: {game: player_model.game, seat: player_model.seat},
          amount: money_earned,
          reason: 'for selling top secret information'
        )
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
