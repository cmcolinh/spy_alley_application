# frozen string literal: true

require 'dry-initializer'

module SpyAlleyApplication
  module Actions
    class ChooseSpaceToMove
      include Dry::Initializer.define -> do
        option :process_landing_on_space, type: ::Types::Callable, reader: :private
      end

      def call(game_board:, change_orders:, space_id:)
        process_landing_on_space.(
          game_board: game_board,
          change_orders: change_orders,
          space_id: space_id)
      end
    end
  end
end

