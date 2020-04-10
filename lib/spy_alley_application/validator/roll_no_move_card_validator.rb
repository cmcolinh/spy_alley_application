# frozen_string_literal: true

require 'dry/validation'
require 'dry/initializer'

module SpyAlleyApplication
  class Validator
    class RollNoMoveCardValidator < Dry::Validation::Contract
      extend Dry::Initializer
      option :next_player_id
      option :roll_options
      option :accusation_targets
      option :accusable_nationalities
      option :action_id
      option :user, user -> user || NonLoggedInUser::new
      params do
        legal_options = %w(roll make_accusation)
        required(:last_action_id).filled(:string)
        required(:user).filled
        required(:player_action).filled(:string,  included_in?: legal_options)
        optional(:choose_result).filled(:integer, included_in?: [1,2,3,4,5,6])
        optional(:player_to_accuse).filled(:string)
        optional(:nationality).filled(:string)
      end
      rule(:player_to_accuse) do
        key.failure({text: 'choosing a player to accuse not allowed unless you are making accusation', status: 400}) if !values[:player_action].eql?('make_accusation') && !values[:player_to_accuse].nil?
        key.failure({text: 'not allowed to accuse that player', status: 422}) if values[:player_action].eql?('make_accusation') && !accusation_targets.include?(values[:player_to_accuse])
      end
      rule(:nationality) do
        nationalities = %w(french german spanish italian american russian)
        key.failure({text: 'choosing a nationality is not allowed unless either making an accusation or choosing a new spy identity', status: 400}) if !values[:player_action].eql?('make_accusation') && !values[:nationality].nil?
        key.failure({text: 'not a valid nationality', status: 422}) if values[:player_action].eql?('make_accusation') && !accusable_nationalities.include?(values[:nationality])
      end
      rule(:choose_result) do
        key.failure({text: "cannot choose value #{values[:choose_result]} for the die roll", status: 422}) if values[:player_action].eql?('roll') && !values[:choose_result].nil? && !roll_options.eql?(:permit_choose_result)
        key.failure({text: 'attempting to set the result of the die roll not permitted when not rolling the dice', status: 400}) if !values[:player_action].eql?('roll') && !values[:choose_result].nil?
        key.failure({text: 'normal users cannot manipulate the die roll', status: 403}) if values[:last_action_id].eql?(action_id) && !user&.admin?
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
