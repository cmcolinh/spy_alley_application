# frozen_string_literal: true

require 'dry/validation'
require 'dry/initializer'

module SpyAlleyApplication
  class Validator
    class ChooseNewIdentityValidator < Dry::Validation::Contract
      extend Dry::Initializer
      option :nationality_options
      option :return_options
      option :action_id, optional: true
      option :user, -> user {user || NonLoggedInUser::new}
      params do
        required(:last_action_id).filled(:string)
        required(:user).filled
        required(:player_action).filled(:string, eql?: 'choose_spy_identity')
        required(:nationality).filled(:string)
        required(:return_player).filled(:integer, included_in?: (1..6))
        optional(:remaining_choices).filled(:array)
      end
      rule(:nationality) do
        key.failure({text: 'not a valid nationality', status: 422}) if !nationality_options.include?(values[:nationality])
      end
      rule(:last_action_id) do
        key.failure({text: 'not posting to the current state of the game', status: 409}) if !values[:last_action_id].eql?(action_id)
      end
      rule(:user) do
        key.failure({text: 'not your turn', status: 403}) if values[:last_action_id].eql?(action_id) && !user&.id.eql?(next_player_id) && !user&.admin?
      end

      def call(input)
        input.reject!{|k, v| [:return_player, :remaining_choices, :user].include?(k)}
        input[:user] = user
        input[:return_player] = return_options[:player]
        input[:remaining_choices] = return_options[:choices] if return_options.has_key?(:choices)
        super
      end
    end
  end
end
