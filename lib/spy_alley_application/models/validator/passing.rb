# frozen string literal: true

require 'dry-struct'
require 'game_validator/validator/validate_to_action'
require 'spy_alley_application/validator/no_options'

module SpyAlleyApplication
  module Models
    module Validator
      class Passing < Dry::Struct
        attribute :name, ::Types.Value('pass')
        attribute :wrap_result, ::Types::Callable

        def build(options={})
          @validate_to_action ||= GameValidator::Validator::ValidateToAction::new(
            validate: SpyAlleyApplication::Validator::NoOptions,
            wrap: wrap_result)
          @validate_to_action
        end
      end
    end
  end
end

