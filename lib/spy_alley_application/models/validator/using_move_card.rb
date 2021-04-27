# frozen string literal: true

require 'dry-struct'
require 'game_validator/validator/validate_to_action'
require 'spy_alley_application/types/nationality'
require 'spy_alley_application/validator/use_move_card'

module SpyAlleyApplication
  module Models
    module Validator
      class UsingMoveCard < Dry::Struct
        attribute :name, ::Types.Value('use_move_card')
        attribute :card_list, ::Types::ArrayOfStrictInteger
        attribute :wrap_result, ::Types::Callable

        def build(options={})
          @validate_to_action ||= GameValidator::Validator::ValidateToAction::new(
            validate: validate,
            wrap: wrap_result)
          @validate_to_action
        end

        private
        def validate
          SpyAlleyApplication::Validator::UseMoveCard::new(card_list: card_list)
        end
      end
    end
  end
end

