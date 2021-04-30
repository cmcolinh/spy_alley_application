# frozen string literal: true

require 'dry-validation'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Validator
    class NewGame < Dry::Validation::Contract
      params do
        required(:seat_assignments).array(:hash) do
          required(:id).filled(:integer)
          optional(:seat).filled(SpyAlleyApplication::Types::CoercibleIntegerOneToSix)
        end
      end

      rule(:seat_assignments) do
        id_list = values[:seat_assignments].map{|s| s[:id]}
        seat_list = values[:seat_assignments].map{|s| s[:seat]}.reject(&:nil?)

        if values[:seat_assignments].size < 2 || values[:seat_assignments].size > 6
          key.failure({text: 'must be between 2 and 6 players', status: 400})
        end

        if !id_list.uniq.size.eql?(id_list.size)
          key.failure({text: 'all player ids must be distinct', status: 400})
        end

        if !seat_list.uniq.size.eql?(seat_list.size)
          key.failure({text: 'all player seats must be distinct', status: 400})
        end
      end
    end
  end
end

