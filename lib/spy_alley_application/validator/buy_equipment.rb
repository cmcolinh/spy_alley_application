# frozen string literal: true

require 'dry-validation'
require 'spy_alley_application/types/array_of_equipment'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Validator
    class BuyEquipment < Dry::Validation::Contract
      t = SpyAlleyApplication::Types
      @@equipment_regex =
        /\A(#{t::Nationality.values.join('|')}) (#{t::EquipmentType.values.join('|')})\z/

      option :options, type: SpyAlleyApplication::Types::ArrayOfEquipment
      option :limit, type: SpyAlleyApplication::Types::CoercibleIntegerOneToSix

      params do
        required(:equipment_to_buy)
          .filled(::Types::Array::of(::Types::String.constrained(format: @@equipment_regex)))
      end

      rule(:equipment_to_buy) do
        opts = options.map(&:to_s)
        if !values[:equipment_to_buy].all?{|e| opts.include?(e)}
          key.failure({text: "non allowable equipment is included", status: 422})
        end

        if !values[:equipment_to_buy].uniq.size.eql?(values[:equipment_to_buy].size)
          key.failure({text: 'all equipment bought must be distinct', status: 400})
        end

        if values[:equipment_to_buy].size > limit
          key.failure({text: "buying too many items, limit is #{limit}", status: 400})
        end
      end
    end
  end
end

