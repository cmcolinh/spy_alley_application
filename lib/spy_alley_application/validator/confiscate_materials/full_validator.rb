# frozen string literal: true

require 'dry-validation'
require 'spy_alley_application/types/array_of_equipment'

module SpyAlleyApplication
  module Validator
    class ConfiscateMaterials
      class FullValidator < Dry::Validation::Contract
        t = SpyAlleyApplication::Types
        @@equipment_regex =
          /\A(#{t::Nationality.values.join('|')}) (#{t::EquipmentType.values.join('|')})\z/

        option :target_player_id, type: ::Types::Coercible::Integer
        option :targetable_equipment, type: SpyAlleyApplication::Types::ArrayOfEquipment

        params do
          required(:target_player_id).filled(::Types::Coercible::Integer)
          required(:equipment_to_confiscate)
            .filled(::Types::String.constrained(format: @@equipment_regex))
        end

        rule(:target_player_id) do
          if !target_player_id.eql?(values[:target_player_id])
            key.failure({text: "'#{values[:target_player_id]}' not allowable", status: 422})
          end
        end

        rule(:equipment_to_confiscate) do
          opts = targetable_equipment.map(&:to_s)
          if !opts.include?(values[:equipment_to_confiscate])
            key.failure({text: "'#{values[:equipment_to_confiscate]}' not allowable", status: 422})
          end
        end
      end
    end
  end
end

