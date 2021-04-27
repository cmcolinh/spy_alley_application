# frozen string literal: true

require 'dry-struct'
require 'game_validator/validator/validate_to_action'
require 'spy_alley_application/types/array_of_equipment'
require 'spy_alley_application/types/coercible_integer_one_to_six'
require 'spy_alley_application/validator/buy_equipment'

module SpyAlleyApplication
  module Models
    module Validator
      class BuyingEquipment < Dry::Struct
        attribute :name, ::Types::Value('buy_equipment')
        attribute :options, SpyAlleyApplication::Types::ArrayOfEquipment
        attribute :limit, SpyAlleyApplication::Types::CoercibleIntegerOneToSix
        attribute :wrap_result, ::Types::Callable

        def build(options={})
          @validate_to_action ||= GameValidator::Validator::ValidateToAction::new(
            validate: validate,
            wrap: wrap_result)
          @validate_to_action
        end

        private
        def validate
          SpyAlleyApplication::Validator::BuyEquipment::new(
            options: options,
            limit: limit)
        end
      end
    end
  end
end

