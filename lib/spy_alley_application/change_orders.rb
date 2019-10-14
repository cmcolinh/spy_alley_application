require 'dry/initializer'
require 'dry/types'

module SpyAlleyApplication
  class ChangeOrders
    def initialize
      @changes = []
    end

    def changes
      @changes.map{|e| e.dup}
    end

    def get_action_hash
      action_node = nil
      @changes.delete_if{|v| action_node = v if v.is_a?(ActionHashElement)}
      return action_node&.action_hash || {}
    end

    def add_die_roll(player:, rolled:)
      action_hash = get_action_hash
      action_hash[:player_action] = 'roll'
      action_hash[:rolled]        = rolled

      @changes.push(
        DieRoll.new(
          player: player,
          rolled: rolled
        )
      ).push(ActionHashElement.new(action_hash: action_hash))
    end

    def add_admin_die_roll(player:, result_chosen:)
      action_hash = get_action_hash
      action_hash[:player_action] = 'roll'
      action_hash[:rolled]        = result_chosen
      action_hash[:admin_set?]    = true

      @changes.push(
        AdminDieRoll.new(
          player:        player,
          result_chosen: result_chosen
        )
      ).push(ActionHashElement.new(action_hash: action_hash))
    end

    def add_use_move_card(player:, card_to_use:)
      action_hash = get_action_hash
      action_hash[:player_action] = 'use_move_card'
      action_hash[:card_to_use]   = card_to_use

      @changes.push(
        UseMoveCard.new(
          player: player,
          card_to_use: card_to_use
        )
      ).push(
        PlaceCardAtBottomOfMoveCardDeck.new(card: card_to_use)
      ).push(ActionHashElement.new(action_hash: action_hash))
    end

    def add_move_action(player:, space:)
      action_hash = get_action_hash
      action_hash[:player_action] = 'move'
      action_hash[:space]         = space

      @changes.push(
        MoveAction.new(
          player: player,
          space_to_move: space
        )
      ).push(ActionHashElement.new(action_hash: action_hash))
    end

    def add_money_action(player:, amount:, reason:)
      action_hash = get_action_hash
      action_hash[:result] ||= {}
      action_hash[:result][:collect] = "$#{amount} for #{reason}"

      @changes.push(
        AddMoney.new(
          player: player,
          amount: amount
        )
      ).push(ActionHashElement.new(action_hash: action_hash))
    end

    def subtract_money_action(player:, amount:, paid_to:)
      @changes.push(
        SubtractMoney.new(
          player: player,
          amount: amount
        )
      )
    end

    def add_pass_action
      action_hash = get_action_hash
      action_hash[:player_action] = 'pass'

      @changes.push(ActionHashElement.new(action_hash: action_hash))
    end

    def add_equipment_action(player:, equipment:)
      @changes.push(
        AddEquipment.new(
          player: player,
          equipment: equipment
        )
      )
    end

    def add_action(action_to_add_as_hash)
      action_hash = get_action_hash
      if action_to_add_as_hash.has_key?(:result) && action_to_add_as_hash.is_a?(Hash)
        action_hash[:result] ||= {}
        action_hash[:result].merge!(action_to_add_as_hash[:result])
      end
      action_hash.merge!(action_to_add_as_hash.reject{|k, v| k.eql?(:result)})

      @changes.push(ActionHashElement.new(action_hash: action_hash))
    end

    def subtract_equipment_action(player:, equipment:)
      @changes.push(
        SubtractEquipment.new(
          player: player,
          equipment: equipment
        )
      )
    end

    def eliminate_player_action(player:)
      @changes.push(EliminatePlayer.new(player: player))
    end

    def add_wild_card_action(player:)
      @changes.push(AddWildCard::new(player: player))
    end

    def subtract_wild_card_action(player:)
      @changes.push(SubtractWildCard::new(player: player))
    end

    def add_move_options(options:)
      @changes.push(
        NextActionOptions::new(
          option: {move: {space: options}}
        )
      )
    end 

    def add_buy_equipment_option(equipment:, limit:)
      @changes.push(NextActionOptions::new(option: {pass: true}))
      @changes.push(
        NextActionOptions::new(
          option: {
            buy_equipment: {
              equipment_to_buy: equipment,
              buy_limit: limit
            }
          }
        )
      )
    end

    class DieRoll
      extend Dry::Initializer
      option :player, type: Dry::Types['strict.hash']
      option :rolled, type: Dry::Types['strict.integer'].constrained(included_in: (1..6))
    end

    class AdminDieRoll
      extend Dry::Initializer
      option :player,        type: Dry::Types['strict.hash']
      option :result_chosen, type: Dry::Types['strict.integer'].constrained(included_in: (1..6))
    end

    class AddMoveCard
      extend Dry::Initializer
      option :player,      type: Dry::Types['strict.hash']
      option :card_to_add, type: Dry::Types['strict.integer'].constrained(included_in: (1..6))
    end

    class UseMoveCard
      extend Dry::Initializer
      option :player,      type: Dry::Types['strict.hash']
      option :card_to_use, type: Dry::Types['strict.integer'].constrained(included_in: (1..6))
    end

    class DrawTopMoveCard
    end

    class PlaceCardAtBottomOfMoveCardDeck
      extend Dry::Initializer
      option :card, type: Dry::Types['strict.integer'].constrained(included_in: (1..6))
    end

    class MoveAction
      extend Dry::Initializer
      option :player,        type: Dry::Types['strict.hash']
      option :space_to_move, type: Dry::Types['strict.integer'].constrained(included_in: (0..32))
    end

    class AddMoney
      extend Dry::Initializer
      option :player, type: Dry::Types['strict.hash']
      option :amount, type: Dry::Types['strict.integer'].constrained(gt: 0)
    end

    class SubtractMoney
      extend Dry::Initializer
      option :player, type: Dry::Types['strict.hash']
      option :amount, type: Dry::Types['strict.integer'].constrained(gt: 0)
    end

    class AddEquipment
      extend Dry::Initializer
      all_equipment = []
      nationalities = %w(french german spanish italian american russian)
      equipment     = %w(password disguise codebook key)
      nationalities.each{|n| equipment.each{|e| all_equipment.push("#{n} #{e}")}}
      
      option :player,    type: Dry::Types['strict.hash']
      option :equipment, type: Dry::Types['strict.string'].constrained(included_in: all_equipment)
    end

    class SubtractEquipment
      extend Dry::Initializer
      all_equipment = []
      nationalities = %w(french german spanish italian american russian)
      equipment     = %w(password disguise codebook key)
      nationalities.each{|n| equipment.each{|e| all_equipment.push("#{n} #{e}")}}
      
      option :player,    type: Dry::Types['strict.hash']
      option :equipment, type: Dry::Types['strict.string'].constrained(included_in: all_equipment)
    end

    class EliminatePlayer
      extend Dry::Initializer
      option :player, type: Dry::Types['strict.hash']
    end

    class IncorrectFreeGuess
      extend Dry::Initializer
      option :player_accused, type: Dry::Types['strict.hash']
    end

    class AddWildCard
      extend Dry::Initializer
      option :player, type: Dry::Types['strict.hash']
    end

    class SubtractWildCard
      extend Dry::Initializer
      option :player, type: Dry::Types['strict.hash']
    end

    class ActionHashElement
      extend Dry::Initializer
      option :action_hash, type: Dry::Types['strict.hash']
    end

    class NextActionOptions
      extend Dry::Initializer
      option :option, type: Dry::Types['strict.hash']
    end
  end
end    
