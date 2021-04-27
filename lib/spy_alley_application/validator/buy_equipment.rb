# frozen string literal: true

require 'dry-validation'
require 'spy_alley_application/types/array_of_equipment'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Validator
    class BuyEquipment < Dry::Validation::Contract
      option :options, type: SpyAlleyApplication::Types::ArrayOfEquipment
      option :limit, type: SpyAlleyApplication::Types::CoercibleIntegerOneToSix

      params do
        required(:equipment_to_buy)
          .filled(::Types::Array::of(SpyAlleyApplication::Types::Equipment.schema))
      end

      rule(:equipment_to_buy) do
        if !values[:equipment_to_buy].all?{|e|
          options.include?(SpyAlleyApplication::Models::Equipment::call(e))}

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

