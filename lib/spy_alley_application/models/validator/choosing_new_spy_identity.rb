# frozen string literal: true

require 'dry-struct'
require 'game_validator/validator/validate_to_action'
require 'spy_alley_application/types/array_of_equipment'
require 'spy_alley_application/types/coercible_integer_one_to_six'
require 'spy_alley_application/validator/choose_new_spy_identity'

module SpyAlleyApplication
  module Models
    module Validator
      class ChoosingNewSpyIdentity < Dry::Struct
        attribute :name, ::Types.Value('choose_new_spy_identity')
        attribute :options, ::Types::Array::of(SpyAlleyApplication::Types::Nationality)
          .constrained(size: 2)
        attribute :wrap_result, ::Types::Callable

        def build(options={})
          @validate_to_action ||= GameValidator::Validator::ValidateToAction::new(
            validate: validate,
            wrap: wrap_result)
          @validate_to_action
        end

        private
        def validate
          SpyAlleyApplication::Validator::ChooseNewSpyIdentity::new(options: options)
        end
      end
    end
  end
end

