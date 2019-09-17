# frozen_string_literal: true

require 'dry/validation'
require 'dry/initializer'

module SpyAlleyApplication
  class Validator
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
  end
end
