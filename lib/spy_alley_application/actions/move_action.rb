# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/move_result'

module SpyAlleyApplication
  module Actions
    class MoveAction
      extend Dry::Initializer
      option :move_result,  default: ->{SpyAlleyApplication::Results::MoveResult::new}

      def call(player_model:, change_orders:, action_hash:, target_player_model: nil)
        money_per_lap = 15
        space_to_move = action_hash[:space]
        puts space_to_move
        change_orders.add_move_action(
          player: {game: player_model.game, seat: player_model.seat},
          space: space_to_move
        )
        move_result.(
          player_model:  player_model,
          change_orders: change_orders,
          action_hash:   action_hash,
          space_to_move: space_to_move
        )
        space_to_move
      end
    end
  end
end
