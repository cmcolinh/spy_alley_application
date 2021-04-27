# frozen_string_literal: true

require 'dry-auto_inject'
require 'spy_alley_application/injection_container'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  class ExecuteAction
    include Dry::AutoInject(SpyAlleyApplication::InjectionContainer)[
      :change_orders_initializer, :build_validator]

    def call(action_hash:, game_board:, user:, last_action_id:)
      game_board = SpyAlleyApplication::Types::GameBoard.call(game_board.to_h)
      validate = build_validator.(game_board: game_board, last_action_id: last_action_id)
      execute_action = validate.(action_hash: action_hash, user: user)
      execute_action.(game_board: game_board, change_orders: change_orders_initializer.())
    end
  end
end

