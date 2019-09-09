require 'dry/validation'

module SpyAlleyApplication
  class Validator
    def self.new(accept_roll: nil, accept_pass: nil, accept_use_move_card: nil,
      accept_make_accusation: nil, accept_move: nil, accept_buy_equipment: nil,
      accept_confiscate_materials: nil, accept_choose_new_identity: nil
    )
      #assemble a list of all the options that are not null
      options_set = local_variables.select{|v| !binding.local_variable_get(v).nil?}.sort

      # look at all the paths one at a time, first off, the roll, accuse and (maybe) use move card path
      if options_set.eql?([:accept_roll, :accept_make_accusation].sort)
        return RollNoMoveCardValidator::new(
          roll_options:           accept_roll,
          accusation_targets:     accept_make_accusation[:player],
          accusable_nationalities: accept_make_accusation[:nationality]
        )
      end
      if options_set.eql?([:accept_roll, :accept_make_accusation, :accept_use_move_card].sort)
        return RollOrMoveCardValidator::new(
          roll_options:            accept_roll,
          accusation_targets:      accept_make_accusation[:player],
          accusable_nationalities: accept_make_accusation[:nationality],
          move_card_options:       accept_use_move_card
        )
      end
      # the next path to explore is the "buy equipment path
      if options_set.eql?([:accept_buy_equipment, :accept_pass].sort) &&
        accept_buy_equipment.is_a?(Hash) &&
          [:equipment, :limit].all?{|field| accept_buy_equipment.include?(field)}
      then
        return BuyEquipmentValidator::new(
          buyable_equipment: accept_buy_equipment[:equipment],
          buy_limit:         accept_buy_equipment[:limit]
        )
      end
      # the next path to explore is the "choose space to move" path
      if options_set.eql?([:accept_move]) && accept_move.is_a?(Array) && accept_move.length.eql?(2)
        return MoveValidator::new(space_options: accept_move)
      end
      # the next path to explore is the Spy Eliminator "accuse or pass" path
      if options_set.eql?([:accept_make_accusation, :accept_pass].sort)
        return SpyEliminatorValidator::new(
          accusation_targets:      accept_make_accusation[:player],
          accusable_nationalities: accept_make_accusation[:nationality]
        )
      end
      # the next path to explore is the "confiscate materials" path
      if options_set.eql?([:accept_confiscate_materials, :accept_pass].sort)
        return ConfiscateMaterialsValidator::new(selectable_options: accept_confiscate_materials)
      end
      # the next path to explore is the "choose new identity" path
      if options_set.eql?([:accept_choose_new_identity])
        return ChooseNewIdentityValidator::new(nationality_options: accept_choose_new_identity)
      end
      raise "set option list #{options_set} invalid!!!!"
    end

    class RollNoMoveCardValidator < Dry::Validation::Contract
      extend Dry::Initializer
      option :roll_options
      option :accusation_targets
      option :accusable_nationalities
      params do
        legal_options = %w(roll make_accusation)
        seats         = %w(seat_1, seat_2, seat_3, seat_4, seat_5, seat_6)
        required(:player_action).filled(:string,  included_in?: legal_options)
        optional(:choose_result).filled(:integer, included_in?: [1,2,3,4,5,6])
        optional(:player_to_accuse).filled(:string)
        optional(:nationality).filled(:string)
      end
      rule(:player_to_accuse) do
        key.failure({text: 'choosing a player to accuse not allowed unless you are making accusation', status: 400}) if !values[:player_action].eql?('make_accusation') && !values[:player_to_accuse].nil?
        key.failure({text: 'not allowed to accuse that player', status: 422}) if values[:player_action].eql?('make_accusation') && !accusation_targets.include?(values[:player_to_accuse])
      end
      rule(:nationality) do
        nationalities = %w(french german spanish italian american russian)
        key.failure({text: 'choosing a nationality is not allowed unless either making an accusation or choosing a new spy identity', status: 400}) if !values[:player_action].eql?('make_accusation') && !values[:nationality].nil?
        key.failure({text: 'not a valid nationality', status: 422}) if values[:player_action].eql?('make_accusation') && !accusable_nationalities.include?(values[:nationality])
      end
      rule(:choose_result) do
        key.failure({text: "cannot choose value #{values[:choose_result]} for the die roll", status: 422}) if values[:player_action].eql?('roll') && !values[:choose_result].nil? && !roll_options.eql?(:permit_choose_result)
        key.failure({text: 'attempting to set the result of the die roll not permitted', status: 400}) if !values[:player_action].eql?('roll') && !values[:choose_result].nil?
      end
    end

    class RollOrMoveCardValidator < Dry::Validation::Contract
      extend Dry::Initializer
      option :roll_options
      option :accusation_targets
      option :accusable_nationalities
      option :move_card_options
      params do
        legal_options = %w(roll make_accusation use_move_card)
        seats         = %w(seat_1, seat_2, seat_3, seat_4, seat_5, seat_6)
        required(:player_action).filled(:string,  included_in?: legal_options)
        optional(:choose_result).filled(:integer, included_in?: [1,2,3,4,5,6])
        optional(:player_to_accuse).filled(:string)
        optional(:nationality).filled(:string)
        optional(:card_to_use).filled(:integer)
      end
      rule(:player_to_accuse) do
        key.failure({text: 'choosing a player to accuse not allowed unless you are making accusation', status: 400}) if !values[:player_action].eql?('make_accusation') && !values[:player_to_accuse].nil?
        key.failure({text: 'not allowed to accuse that player', status: 422}) if values[:player_action].eql?('make_accusation') && !accusation_targets.include?(values[:player_to_accuse])
      end
      rule(:nationality) do
        nationalities = %w(french german spanish italian american russian)
      key.failure({text: 'choosing a nationality is not allowed unless either making an accusation or choosing a new spy identity', status: 400}) if !values[:player_action].eql?('make_accusation') && !values[:nationality].nil?
        key.failure({text: 'not a valid nationality', status: 422}) if values[:player_action].eql?('make_accusation') && !accusable_nationalities.include?(values[:nationality])
      end
      rule(:choose_result) do
        key.failure({text: "cannot choose value #{values[:choose_result]} for the die roll", status: 422}) if values[:player_action].eql?('roll') && !values[:choose_result].nil? && !roll_options.eql?(:permit_choose_result)
        key.failure({text: 'attempting to set the result of the die roll not permitted', status: 400}) if !values[:player_action].eql?('roll') && !values[:choose_result].nil?
      end
      rule(:card_to_use) do
        key.failure({text: 'choosing a card to use not allowed unless you are using move card', status: 400}) if !values[:player_action].eql?('use_move_card') && !values[:card_to_use].nil?
        key.failure({text: 'not allowed to use that particular move card', status: 422}) if values[:player_action].eql?('use_move_card') && !move_card_options.include?(values[:card_to_use])
      end
    end

    class BuyEquipmentValidator < Dry::Validation::Contract
      extend Dry::Initializer
      option :buyable_equipment
      option :buy_limit

      params do
        legal_options = %w(buy_equipment pass)
        required(:player_action).filled(:string, included_in?: legal_options)
        optional(:equipment_to_buy).filled(:array)
      end

      rule(:equipment_to_buy) do
        key.failure({text: 'choosing equipment to buy not allowed unless choosing to buy equipment', status: 400}) if !values[:player_action].eql?('buy_equipment') && !values[:equipment_to_buy].nil?
        key.failure({text: 'must choose equipment to buy when choosing to buy equipment', status: 400}) if values[:player_action].eql?('buy_equipment') && values[:equipment_to_buy].nil?
        key.failure({text: 'not all equipment valid', status: 422}) if values[:player_action].eql?('buy_equipment') && !Array(values[:equipment_to_buy]).all?{|value| buyable_equipment.include?(value)}
        key.failure({text: "limited to buying #{buy_limit} different equipment", status: 400}) if Array(values[:equipment_to_buy]).length > buy_limit
      end
    end

    class MoveValidator < Dry::Validation::Contract
      extend Dry::Initializer
      option :space_options

      params do
        required(:player_action).filled(:string, eql?: 'move')
        required(:space).filled(:string)
      end
      rule(:space) do
        key.failure({text: 'not a valid space to move to', status: 422}) if values[:player_action].eql?('move') && !space_options.include?(values[:space])
      end
    end

    class SpyEliminatorValidator < Dry::Validation::Contract
      option :accusation_targets
      option :accusable_nationalities
      params do
        legal_options = %w(pass make_accusation)
        required(:player_action).filled(:string,  included_in?: legal_options)
        optional(:player_to_accuse).filled(:string)
        optional(:nationality).filled(:string)
      end
      rule(:player_to_accuse) do
        key.failure({text: 'choosing a player to accuse not allowed unless you are making accusation', status: 400}) if !values[:player_action].eql?('make_accusation') && !values[:player_to_accuse].nil?
        key.failure({text: 'not allowed to accuse that player', status: 422}) if values[:player_action].eql?('make_accusation') && !accusation_targets.include?(values[:player_to_accuse])
      end
      rule(:nationality) do
        key.failure({text: 'choosing a nationality is not allowed unless either making an accusation or choosing a new spy identity', status: 400}) if !values[:player_action].eql?('make_accusation') && !values[:nationality].nil?
        key.failure({text: 'not a valid nationality', status: 422}) if values[:player_action].eql?('make_accusation') && !accusable_nationalities.include?(values[:nationality])
      end
    end

    class ConfiscateMaterialsValidator < Dry::Validation::Contract
      option :selectable_options
      params do
        legal_options = %w(pass confiscate_materials)
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
    end

    class ChooseNewIdentityValidator < Dry::Validation::Contract
      option :nationality_options
      params do
        required(:player_action).filled(:string, eql?: 'choose_spy_identity')
        optional(:nationality).filled(:string)
      end
      rule(:nationality) do
        key.failure({text: 'not a valid nationality', status: 422}) if values[:player_action].eql?('choose_spy_identity') && !nationality_options.include?(values[:nationality])
      end
    end
  end
end

