# frozen_string_literal: true

require 'dry-auto_inject'
require 'spy_alley_application/injection_container'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  class NewGame
    include Dry::AutoInject(SpyAlleyApplication::InjectionContainer)[
      :change_orders_initializer, validate: :build_new_game_validator]

    def call(action_hash:, user:)
      execute_action = validate.(action_hash: action_hash, user: user)
      execute_action.(change_orders: change_orders_initializer.())
    end
  end
end

