# frozen_string_literal: true

require 'dry/validation'
require 'dry/initializer'

module SpyAlleyApplication
  class Validator
    class ChooseNewIdentityValidator < Dry::Validation::Contract
      extend Dry::Initializer
      option :nationality_options
      option :return_options
      params do
        required(:player_action).filled(:string, eql?: 'choose_spy_identity')
        required(:nationality).filled(:string)
        required(:return_player).filled(:integer, included_in?: (1..6))
        optional(:remaining_choices).filled(:array)
      end
      rule(:nationality) do
        key.failure({text: 'not a valid nationality', status: 422}) if !nationality_options.include?(values[:nationality])
      end

      def call(input)
        input.reject!{|k, v| [:return_player, :remaining_choices].include?(k)}
        input[:return_player] = return_options[:player]
        input[:remaining_choices] = return_options[:choices] if return_options.has_key?(:choices)
        super
      end
    end
  end
end
