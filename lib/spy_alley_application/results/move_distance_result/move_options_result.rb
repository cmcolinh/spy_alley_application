# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class MoveDistanceResult
      class MoveOptionsResult
        def call(change_orders:, move_options:)
          change_orders.add_move_options(options: move_options)
          move_options
        end
      end
    end
  end
end

