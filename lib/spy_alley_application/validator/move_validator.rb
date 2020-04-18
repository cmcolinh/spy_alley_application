# frozen_string_literal: true

require 'dry/validation'
require 'dry/initializer'

module SpyAlleyApplication
  class Validator
    class MoveValidator < Dry::Validation::Contract
      extend Dry::Initializer
      option :space_options
      option :last_action_id
      option :user, -> user {user|| NonLoggedInUser::new}

      params do
        required(:last_action_id).filled(:string)
        required(:user).filled
        required(:player_action).filled(:string, eql?: 'move')
        required(:space).filled(:string)
      end
      rule(:space) do
        key.failure({text: 'not a valid space to move to', status: 422}) if values[:player_action].eql?('move') && !space_options.include?(values[:space])
      end
      rule(:last_action_id) do
        key.failure({text: 'not posting to the current state of the game', status: 409}) if !values[:last_action_id].eql?(action_id)
      end
      rule(:user) do
        key.failure({text: 'not your turn', status: 403}) if values[:last_action_id].eql?(action_id) && !user&.id.eql?(next_player_id) && !user&.admin?
      end

      def call(input)
        input.reject!{|k, v| k.eql?(:user)}
        input[:user] = user
        super
      end
    end
  end
end
