# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/move_result/finished_lap'

module SpyAlleyApplication
  module Results
    class MoveResult
      extend Dry::Initializer
      option :finished_lap, default: ->{SpyAlleyApplication::Results::MoveResult::FinishedLap::new}
      option :get_result_for, default: ->{SpyAlleyApplication::ResultCreator::new}

      def call(player_model:, action_hash:, change_orders:, space_to_move:, decks_model: nil)
        if finished_lap.(previous_location: player_model.location, space_to_move: space_to_move)
          change_orders.add_money_action(
            player: {game: player_model.game, seat: player_model.seat},
            amount: money_per_lap,
            reason: 'passing start'
          )
        end
        get_result_for.(space_to_move).(
          player_model:  player_model,
          action_hash:   action_hash,
          change_orders: change_orders,
          decks_model:   decks_model
        )
      end
    end
  end
end
