# frozen string literal: true

require 'dry-validation'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Validator
    class UseMoveCard < Dry::Validation::Contract
      option :card_list, ::Types::ArrayOfStrictInteger

      params do
        required(:card_to_use).filled(::Types::Coercible::Integer)
      end

      rule(:card_to_use) do
        if !card_list.include?(values[:card_to_use])
          key.failure({text: "'#{values[:card_to_use]}' not allowable", status: 422})
        end
      end
    end
  end
end

