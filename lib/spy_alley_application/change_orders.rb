module SpyAlleyApplication
  class ChangeOrders
    def initialize
      @changes = []
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
      ).push(ActionHashElement.new(action_hash))
    end

    def add_move_card(player:, card_to_add:)
      

    def add_use_move_card(player_card:, card_to_use:)
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
      ).push(ActionHashElement.new(action_hash))
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
      ).push(ActionHashElement.new(action_hash))
    end

    def add_money_action(player:, amount:, reason:)
      action_hash = get_action_hash
      action_hash[:result] ||= []
      action_hash[:result][:collect] = "$#{amount} for #{reason}"

      @changes.push(
        AddMoney.new(
          player: player,
          amount: amount
        )
      ).push(ActionHashElement.new(action_hash))
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

      @changes.push(ActionHashElement.new(action_hash))
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
      action_hash.merge!(action.to_add_as_hash.reject{|k, v| k.eql?(:result)})

      @changes.push(ActionHashElement.new(action_hash))
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

    def incorrect_free_guess_action(player_accused:)
      action_hash = get_action_hash
      seat        = player_accused[:seat]
      action_hash[:action]           = 'make_accusation'
      action_hash[:player_to_accuse] = "seat_#{seat}"
      
      action_hash[:result] ||= {}
      action_hash[:result][:guess_correct] = false
      @changes.push(
        IncorrectFreeGuess.new(
          player_accused: player_accused,
          seat:           seat
        )
      ).push(ActionHashElement.new(action_hash))
    end

    def add_wild_card_action(player:)
       AddWildCard::new(player: player)
    end

    def subtract_wild_card_action(player:)
       SubtractWildCard::new(player: player)
    end

    def add_move_options(options:)
      @changes.push(
        NextActionOptions.new(
          option: {move: {space: options}}
        )
      )
    end

    class DieRoll
      extend Dry::Initializer
      option :player, type: Dry::Types::Strict::Hash
      option :rolled, type: Dry::Types::Strict::Integer::constrained(included_in?: (1..6))
    end

    class AddMoveCard
      extend Dry::Initializer
      option :player,      type: Dry::Types::Strict::Hash
      option :card_to_add, type: Dry::Types::Strict::Integer::constrained(included_in?: (1..6))
    end

    class UseMoveCard
      extend Dry::Initializer
      option :player,      type: Dry::Types::Strict::Hash
      option :card_to_use, type: Dry::Types::Strict::Integer::constrained(included_in?: (1..6))
    end

    class DrawTopMoveCard
    end

    class PlaceCardAtBottomOfMoveCardDeck
      extend: Dry::Initializer
      option :card, type: Dry::Types::Strict::Integer::constrained(included_in?: (1..6))
    end

    class MoveAction
      extend Dry::Initializer
      option :player,        type: Dry::Types::Strict::Hash
      option :space_to_move, type: Dry::Types::Strict::Integer(included_in?: all_spaces)
    end

    class AddMoney
      extend Dry::Initializer
      option :player, type: Dry::Types::Strict::Hash
      option :amount, type: Dry::Types::Strict::Integer::constrained(gt?: 0)
    end

    class SubtractMoney
      extend Dry::Initializer
      option :player, type: Dry::Types::Strict::Hash
      option :amount, type: Dry::Types::Strict::Integer::constrained(gt?: 0)
    end

    class AddEquipment
      extend Dry::Initializer
      option :player,    type: Dry::Types::Strict::Hash
      option :equipment, type: Dry::Types::Strict::String::constrained(included_in: all_equipment)
    end

    class SubtractEquipment
      extend Dry::Initializer
      option :player,    type: Dry::Types::Strict::Hash
      option :equipment, type: Dry::Types::Strict::String::constrained(included_in: all_equipment)
    end

    class EliminatePlayer
      extend Dry::Initializer
      option :player, type: Dry::Types::Strict::Hash
    end

    class IncorrectFreeGuess
      extend Dry::Initializer
      option :player_accused, type: Dry::Types::Strict::Hash
    end

    class AddWildCard
      extend Dry::Initializer
      option :player, type: Dry::Types::Strict::Hash
    end

    class SubtractWildCard
      extend Dry::Initializer
      option :player, type: Dry::Types::Strict::Hash
    end

    class ActionHashElement
      extend Dry::Initializer
      option :action_hash, type: Dry::Types::Strict::Hash
    end
  end
end    
