# frozen string literal: true

require 'dry-struct'
require 'game_validator/validator/validate_to_action'
require 'spy_alley_application/validator/move'

module SpyAlleyApplication
  module Models
    module Validator
      class Moving < Dry::Struct
        attribute :name, ::Types.Value('move')
        attribute :options, ::Types::ArrayOfStrictInteger.constrained(size: 2)
        attribute :wrap_result, ::Types::Callable

        def build(options={})
          @validate_to_action ||= GameValidator::Validator::ValidateToAction::new(
            validate: validate,
            wrap: wrap_result)
          @validate_to_action
        end

        private
        def validate
          SpyAlleyApplication::Validator::Move::new(options: options)
        end
      end
    end
  end
end

