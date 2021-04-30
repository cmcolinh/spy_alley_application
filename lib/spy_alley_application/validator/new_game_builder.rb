# frozen string literal: true

require 'dry-initializer'
require 'spy_alley_application/types/validation_builder'

module SpyAlleyApplication
  module Validator
    class NewGameBuilder
      include Dry::Initializer.define -> do
        option :assign_seats, type: ::Types::Callable, reader: :private
        option :assign_spy_identities, ::Types::Callable, reader: :private
        option :build_failure, type: ::Types::Callable, 
          default: ->{GameValidator::Validator::Result::Failure::Builder::new}
        option :generate_new_game, type: ::Types::Callable, reader: :private
        option :validate_new_game, type: ::Types::Callable, reader: :private
      end

      def call(action_hash:, user:)
        sa = validate_new_game.(action_hash)
        return ->(**args){build_failure.(errors: sa.errors)} if sa.failure?
        seat_assignments = assign_seats.(sa[:seat_assignments])
        seat_assignments = assign_spy_identities.(seat_assignments)
        ->(change_orders:) do
          generate_new_game.(
            seat_assignments: seat_assignments,
            change_orders: change_orders)
        end
      end
    end
  end
end

