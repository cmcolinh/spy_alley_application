# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class MoveResult
      class FinishedLap
        def call(previous_location:, space_to_move:)
          previous_location.length > space_to_move.length
        end
      end
    end
  end
end
