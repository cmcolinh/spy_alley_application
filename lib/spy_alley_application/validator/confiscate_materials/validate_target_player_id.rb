require 'dry-initializer'
require 'spy_alley_application/types/nationality'
require 'spy_alley_application/validator/make_accusation'

module SpyAlleyApplication
  module Validator
    class ConfiscateMaterials
      class ValidateTargetPlayerId < Dry::Validation::Contract
        option :target_player_id_list, type: ::Types::ArrayOfStrictInteger
        
        params do
          required(:target_player_id).filled(::Types::Coercible::Integer)
        end

        rule(:target_player_id) do
          if !target_player_id_list.include?(values[:target_player_id])
            key.failure({text: "'#{values[:target_player_id]}' not allowable", status: 422})
          end
        end
      end
    end
  end
end

