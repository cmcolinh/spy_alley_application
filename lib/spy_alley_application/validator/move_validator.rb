# frozen_string_literal: true

require 'dry/validation'
require 'dry/initializer'

module SpyAlleyApplication
  class Validator
    class MoveValidator < Dry::Validation::Contract
      extend Dry::Initializer
      option :space_options

      params do
        required(:player_action).filled(:string, eql?: 'move')
        required(:space).filled(:string)
      end
      rule(:space) do
        key.failure({text: 'not a valid space to move to', status: 422}) if values[:player_action].eql?('move') && !space_options.include?(values[:space])
      end
    end
  end
end
