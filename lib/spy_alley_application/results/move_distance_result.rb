# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/results/move_result'
require 'spy_alley_application/results/move_distance_result/move_options'

module SpyAlleyApplication
  module Results
    class MoveDistanceResult
      extend Dry::Initializer
      option :move_options_from, default: ->{SpyApplication::Results::MoveDistanceResult::MoveOptions::new}
      option :move_result, default: ->{SpyAlleyApplication::Results::MoveResult::new}
      def call(player_model:, change_orders:, action_hash:, move_distance:)
        move_options = move_options_from.(location: player_model.location, move_distance: move_distance)
        #if move_distance.length > 1
      end
    end
  end
end
