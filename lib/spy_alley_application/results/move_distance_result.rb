# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/move_result'
require 'spy_alley_application/results/move_distance_result/move_options'

module SpyAlleyApplication
  module Results
    class MoveDistanceResult
      extend Dry::Initializer
      option :move_options_from, default: ->{SpyAlleyApplication::Results::MoveDistanceResult::MoveOptions::new}
      option :get_move_result, default: ->{SpyAlleyApplication::Results::MoveResult::new}
      def call(player_model:, change_orders:, action_hash:, move_distance:)
        move_options = move_options_from.(location: player_model.location, move_distance: move_distance)
        if move_options.length > 1
          SpyAlleyApplication::Results::MoveOptionResult::new(
            player_model:  player_model,
            change_orders: change_orders,
            action_hash:   action_hash,
            move_options:  move_options
          )
        elsif move_options.length.eql? 1
          get_move_result.(
            player_model:  player_model,
            change_orders: change_orders,
            action_hash:   action_hash,
            space_to_move: move_options.first
          )
        end
      end
    end
  end
end

