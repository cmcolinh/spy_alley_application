# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class SpyEliminator
      def call(player_model:, change_orders:, action_hash: nil, target_player_model:, decks_model: nil)
        opponents_in_spy_alley = target_player_model.select{|p| in_spy_alley(p)}.map(&:seat)
        if !opponents_in_spy_alley.empty?
          change_orders.add_spy_eliminator_option(options: opponents_in_spy_alley.map{|s| "seat_#{s}"})
          true # will be same player's turn again
        else
          false # the current player's turn will *not* continue
        end
      end

      def in_spy_alley(opponent_player_model)
        opponent_player_model.location.include?('s')
      end
    end
  end
end
