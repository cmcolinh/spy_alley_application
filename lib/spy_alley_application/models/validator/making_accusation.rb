# frozen string literal: true

require 'dry-struct'
require 'game_validator/validator/validate_to_action'
require 'spy_alley_application/types/nationality'
require 'spy_alley_application/validator/make_accusation'

module SpyAlleyApplication
  module Models
    module Validator
      class MakingAccusation < Dry::Struct
        attribute :name, ::Types.Value('make_accusation')
        attribute :player_id_list, ::Types::ArrayOfStrictInteger
        attribute :wrap_result, ::Types::Callable

        def build(options={})
          @validate_to_action ||= GameValidator::Validator::ValidateToAction::new(
            validate: validate,
            wrap: wrap_result)
          @validate_to_action
        end

        private
        def validate
          SpyAlleyApplication::Validator::MakeAccusation::new(player_id_list: player_id_list)
        end
      end
    end
  end
end

