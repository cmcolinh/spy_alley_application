# frozen_string_literal: true

require 'dry/validation'
require 'dry/initializer'

module SpyAlleyApplication
  class Validator
    class SpyEliminatorValidator < Dry::Validation::Contract
      option :accusation_targets
      option :accusable_nationalities
      params do
        legal_options = %w(pass make_accusation)
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

      def call(input)
        input[:accusation_targets] = accusable_nationalities
        super
      end
    end
  end
end
