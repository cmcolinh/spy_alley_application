# frozen_string_literal: true

require 'dry/validation'
require 'dry/initializer'

module SpyAlleyApplication
  class Validator
    class ConfiscateMaterialsValidator < Dry::Validation::Contract
      option :selectable_options
      option :last_action_id
      params do
        legal_options = %w(pass confiscate_materials)
        required(:last_action_id).filled(:string)
        required(:player_action).filled(:string,  included_in?: legal_options)
        optional(:player_to_confiscate_from).filled(:string)
        optional(:equipment_to_confiscate).filled(:string)
      end
      rule(:player_to_confiscate_from) do
        key.failure({text: 'choosing a player to confiscate from not allowed unless choosing to confiscate materials', status: 400}) if !values[:player_action].eql?('confiscate_materials') && !values[:player_to_confiscate_from].nil?
        key.failure({text: 'player to confiscate from cannot be null when choosing to confiscate materials', status: 400}) if values[:player_action].eql?('confiscate_materials') && values[:player_to_confiscate_from].nil?
        key.failure({text: 'player to confiscate from is invalid', status: 400}) if values[:player_action].eql?('confiscate_materials') && !selectable_options.nil? && !selectable_options.keys.include?(values[:player_to_confiscate_from])
      end
      rule(:equipment_to_confiscate) do
        key.failure({text: 'choosing equipment to confiscate not allowed unless choosing to confiscate equipment', status: 400}) if !values[:player_action].eql?('confiscate_materials') && !values[:equipment_to_confiscate].nil?
        key.failure({text: 'equipment to confiscate cannot be null when choosing to confiscate materials', status: 400}) if values[:player_action].eql?('confiscate_materials') && values[:equipment_to_confiscate].nil?
        key.failure({text: 'cannot confiscate this equipment from this player', status: 422}) if values[:player_action].eql?('confiscate_materials') && selectable_options.keys.include?(values[:player_to_confiscate_from]) && !selectable_options[values[:player_to_confiscate_from]].include?(values[:equipment_to_confiscate])
      end
      rule(:last_action_id) do
        key.failure({text: 'not posting to the current state of the game', status: 409}) if !values[:last_action_id].eql?(action_id)
      end
    end
  end
end
