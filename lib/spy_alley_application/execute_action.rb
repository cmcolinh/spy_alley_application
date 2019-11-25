# frozen_string_literal: true

require 'dry/initializer'
require 'spy_alley_application/change_orders'
require 'spy_alley_application/validator'
require 'spy_alley_application/action_creator'
require 'spy_alley_application/result_creator'

module SpyAlleyApplication
  class ExecuteAction
    extend Dry::Initializer
    option :get_validator_for, default: ->{->(options){SpyAlleyApplication::Validator::new(options)}}
    option :get_action_for, default: ->{->(action_hash){SpyAlleyApplication::ActionCreator::new.(action_hash)}}
    option :new_change_orders, default: ->{->{SpyAlleyApplication::ChangeOrders::new}}
    def call(action:, next_action_options:, player_models:, next_player:, decks_model:)
      action_hash = get_validator_for.(next_action_options).(action)
      raise action.failure if action_hash.failure?
      player_model = player_models.select{|p| p.seat.eql? next_player}.first
      opponent_models = player_models.reject{|p| p.seat.eql? next_player}
      change_orders = new_change_orders.()
      get_action_for.(action_hash).call(
        player_model: player_model,
        opponent_models: opponent_models,
        decks_model: decks_model,
        change_orders: change_orders,
        action_hash: action_hash
      )
      change_orders
    end
  end
end
