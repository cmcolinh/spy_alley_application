# frozen_string_literal: true

require 'dry/validation'
require 'dry/initializer'

module SpyAlleyApplication
  class Validator
    class SpyEliminatorValidator < Dry::Validation::Contract
      option :accusation_targets
      option :accusable_nationalities
      option :action_id
      option :user, -> user {user || NonLoggedInUser::new}

      params do
        legal_options = %w(pass make_accusation)
        required(:last_action_id).filled(:string)
        required(:user).filled
        required(:player_action).filled(:string,  included_in?: legal_options)
        optional(:player_to_accuse).filled(:string)
        optional(:nationality).filled(:string)
        required(:accusation_targets).filled(:array)
      end
      rule(:player_to_accuse) do
        key.failure({text: 'choosing a player to accuse not allowed unless you are making accusation', status: 400}) if !values[:player_action].eql?('make_accusation') && !values[:player_to_accuse].nil?
        key.failure({text: 'not allowed to accuse that player', status: 422}) if values[:player_action].eql?('make_accusation') && !accusation_targets.include?(values[:player_to_accuse])
      end
      rule(:nationality) do
        key.failure({text: 'choosing a nationality is not allowed unless either making an accusation or choosing a new spy identity', status: 400}) if !values[:player_action].eql?('make_accusation') && !values[:nationality].nil?
        key.failure({text: 'not a valid nationality', status: 422}) if values[:player_action].eql?('make_accusation') && !accusable_nationalities.include?(values[:nationality])
      end
      rule(:last_action_id) do
        key.failure({text: 'not posting to the current state of the game', status: 409}) if !values[:last_action_id].eql?(action_id)
      end
      rule(:user) do
        key.failure({text: 'not your turn', status: 403}) if values[:last_action_id].eql?(action_id) && !user&.id.eql?(next_player_id) && !user&.admin?
      end

      def call(input)
        input.reject!{|k, v| [:accusation_targets, :user].include?(k)}
        input[:user] = user
        input[:accusation_targets] = accusable_nationalities
        super
      end
    end
  end
end
