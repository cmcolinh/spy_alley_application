# frozen string literal: true

require 'dry-validation'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Validator
    class MakeAccusation < Dry::Validation::Contract
      option :player_id_list, type: ::Types::ArrayOfStrictInteger

      params do
        required(:target_player_id).filled(::Types::Coercible::Integer)
        required(:nationality).filled(SpyAlleyApplication::Types::Nationality)
      end

      rule(:target_player_id) do
        if !player_id_list.include?(values[:target_player_id])
          key.failure({text: "'#{values[:target_player_id]}' not allowable", status: 422})
        end
      end
    end
  end
end

