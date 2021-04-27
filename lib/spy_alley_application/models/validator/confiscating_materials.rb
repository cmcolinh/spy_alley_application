# frozen string literal: true

require 'dry-struct'
require 'game_validator/validator/validate_to_action'
require 'spy_alley_application/types/array_of_equipment'
require 'spy_alley_application/validator/confiscate_materials'
require 'spy_alley_application/validator/confiscate_materials/full_validator'
require 'spy_alley_application/validator/confiscate_materials/validate_target_player_id'

module SpyAlleyApplication
  module Models
    module Validator
      class ConfiscatingMaterials < Dry::Struct
        attribute :name, ::Types::Value('confiscate_materials')
        attribute :wrap_result, ::Types::Callable
        attribute :target_player, ::Types::Array do
          attribute :target_player_id, ::Types::Coercible::String
          attribute :targetable_equipment, SpyAlleyApplication::Types::ArrayOfEquipment
        end

        def build(options={})
          @validate_to_action ||= GameValidator::Validator::ValidateToAction::new(
            validate: validate,
            wrap: wrap_result)
          @validate_to_action
        end

        private
        def validate
          validate_target_player_id =
            SpyAlleyApplication::Validator::ConfiscateMaterials::ValidatetargetPlayerId::new(
              target_player_id_list: target_player.map(&:target_player_id))
          full_validator_for = target_player.map do |p|
            [ 
              p.target_player_id,
              SpyAlleyApplication::Validator::ConfiscateMaterials::FullValidator::new(
                target_player_id: p.target_player_id,
                targetable_equipment: p.targetable_equipment)
            ]
          end.to_h

          SpyAlleyApplication::Validator::ConfiscateMaterials::new(
            validate_target_player_id: validate_target_player_id,
            full_validator_for: full_validator_for)
        end
      end
    end
  end
end

