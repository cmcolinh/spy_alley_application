# frozen_string_literal: true

require 'spy_alley_application/actions/move_distance_action'
require 'spy_alley_application/actions/pass_action'
require 'spy_alley_application/actions/buy_equipment_action'
require 'spy_alley_application/actions/at_risk_accusation_action'
require 'spy_alley_application/actions/free_accusation_action'
require 'spy_alley_application/actions/confiscate_materials_action'
require 'spy_alley_application/actions/choose_identity_action'

module SpyAlleyApplication
  class ActionCreator
    def call(validation_result)
      case validation_result.to_h.keys.sort
      when [:player_action]
        if validation_result[:player_action].eql?('roll')
          SpyAlleyApplication::Actions::MoveDistanceAction::new(
            move_action: SpyAlleyApplication::Actions::MoveDistanceAction::RollAction::new
          )
        elsif validation_result[:player_action].eql?('pass')
          SpyAlleyApplication::Actions::PassAction::new
        end
      when [:player_action, :choose_result].sort
        if validation_result[:player_action].eql?('roll')
          SpyAlleyApplication::Actions::MoveDistanceAction::new(
            move_action: SpyAlleyApplication::Actions::MoveDistanceAction::AdminRollAction::new
          )
        end
      when [:player_action, :card_to_use].sort
        if validation_result[:player_action].eql?('use_move_card')
          SpyAlleyApplication::Actions::MoveDistanceAction::new(
            move_action: SpyAlleyApplication::Actions::MoveDistanceAction::MoveCardAction::new
          )
        end
      when [:player_action, :equipment_to_buy].sort
        if validation_result[:player_action].eql?('buy_equipment')
          SpyAlleyApplication::Actions::BuyEquipmentAction::new
        end
      when [:player_action, :nationality].sort
        if validation_result[:player_action].eql?('make_accusation')
          SpyAlleyApplication::Actions::AtRiskAccusationAction::new
        elsif validation_result[:player_action].eql?('choose_spy_identity')
          SpyAlleyApplication::Actions::ChooseIdentityAction::new
        end
      when [:player_action, :nationality, :free_accusation].sort
        if validation_result[:player_action].eql?('make_accusation') && validation_result[:free_accusation]
          SpyAlleyApplication::Actions::FreeAccusationAction::new
        end
      when [:player_action, :player_to_confiscate_from, :equipment_to_confiscate].sort
        if validation_result[:player_action].eql?('confiscate_materials')
          SpyAlleyApplication::Actions::ConfiscateMaterialsAction::new
        end
      end
    end
  end
end

