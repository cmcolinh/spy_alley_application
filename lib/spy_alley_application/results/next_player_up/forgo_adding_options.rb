# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class NextPlayerUp
      class ForgoAddingOptions
        def call(next_player_model:, opponent_models:, change_orders:, action_hash:)
          change_orders
        end
      end
    end
  end
end
