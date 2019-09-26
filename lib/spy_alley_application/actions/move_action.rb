# frozen_string_literal: true

include 'dry/initializer'

module SpyAlleyApplication
  module Actions
    class MoveAction
      extend Dry::Initializer
      option :finished_lap, default: ->{SpyAlleyApplication::Results::FinishedLap::new}

      def call(player_model:, change_orders:, action_hash:, target_player_model: nil)
        money_per_lap = 15

        change_orders.add_move_action(
          player: {game: player_model.game, seat: player_model.seat},
          space: space_to_move
        )
  
        if finished_lap.(player_model.location, space_to_move)
          change_orders.add_money_action(
            player: {game: player_model.game, seat: player_model.seat},
            amount: money_per_lap,
            reason: 'passing start'
          )
        end

        space_to_move
      end
    end
  end
end
