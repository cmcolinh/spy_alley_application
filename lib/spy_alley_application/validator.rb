# frozen_string_literal: true

require 'dry/validation'
require 'spy_alley_application/validator/roll_no_move_card_validator'
require 'spy_alley_application/validator/roll_or_move_card_validator'
require 'spy_alley_application/validator/buy_equipment_validator.rb'
require 'spy_alley_application/validator/move_validator.rb'
require 'spy_alley_application/validator/spy_eliminator_validator.rb'
require 'spy_alley_application/validator/confiscate_materials_validator.rb'
require 'spy_alley_application/validator/choose_new_identity_validator.rb'

module SpyAlleyApplication
  class Validator
    Dry::Validation.load_extensions(:monads)
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
  end
end
