# frozen string literal: true

require 'dry-validation'
require 'spy_alley_application/types/array_of_equipment'

module SpyAlleyApplication
  module Validator
    class ConfiscateMaterials
      class FullValidator < Dry::Validation::Contract
        option :target_player_id, type: ::Types::Coercible::Integer
        option :targetable_equipment, type: SpyAlleyApplication::Types::ArrayOfEquipment

        params do
          required(:target_player_id).filled(::Types::Coercible::Integer)
          required(:equipment_to_confiscate).filled(SpyAlleyApplication::Models::Equipment.schema)
        end

        rule(:target_player_id) do
          if !target_player_id.eql?(values[:target_player_id])
            key.failure({text: "'#{values[:target_player_id]}' not allowable", status: 422})
          end
        end

        rule(:equipment_to_confiscate) do
          if !targetable_equipment
            .include?(SpyAlleyApplication::Models::Equipment.(values[:equipment_to_confiscate]))

            key.failure({text: "'#{values[:equipment_to_confiscate]}' not allowable", status: 422})
          end
        end
      end
    end
  end
end

