# frozen string literal: true

require 'dry-struct'
require 'game_validator/validator/validate_to_action'
require 'spy_alley_application/validator/no_options'

module SpyAlleyApplication
  module Models
    module Validator
      class RollingDie < Dry::Struct
        attribute :name, ::Types.Value('roll_die')
        attribute :wrap_result, ::Types::Callable

        def build(options={})
          @validate_to_action ||= GameValidator::Validator::ValidateToAction::new(
            validate: validate,
            wrap: wrap_result)
          @validate_to_action
        end

        private
        def validate
          SpyAlleyApplication::Validator::NoOptions
        end
      end
    end
  end
end

