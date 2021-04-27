# frozen string literal: true

require 'dry-validation'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Validator
    class ChooseNewSpyIdentity < Dry::Validation::Contract
      option :options, type: ::Types::Array::of(SpyAlleyApplication::Types::Nationality)
        .constrained(size: 2)

      params do
        required(:nationality).filled(SpyAlleyApplication::Types::Nationality)
      end

      rule(:nationality) do
        if !options.include?(values[:nationality])
          key.failure({text: "'#{values[:nationality]}' not allowable", status: 422})
        end
      end
    end
  end
end

