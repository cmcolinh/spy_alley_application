# frozen string literal: true

require 'dry-validation'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Validator
    class Move < Dry::Validation::Contract
      option :option, type: ::Types::ArrayOfStrictInteger.constrained(size: 2)

      params do
        required(:space_id).filled(::Types::Coercible::Integer)
      end

      rule(:space_id) do
        if !options.include?(values[:space_id])
          key.failure({text: "'#{values[:space_id]}' not allowable", status: 422})
        end
      end
    end
  end
end


