# frozen_string_literal: true

require 'dry/initializer'

module SpyAlleyApplication
  module Actions
    class MoveDistanceAction
      class RollAction
        extend Dry::Initializer
        option :roll_die, default: ->{->{rand(6) + 1}}
        def call(player_model:, change_orders:, action_hash:)
          die_roll = roll_die.()
          [
            change_orders.add_die_roll(
              player: {game: player_model.game, seat: player_model.seat},
              rolled: die_roll
            ),
            die_roll
          ]
        end
      end
    end
  end
end

