# frozen_string_literal: true

require 'dry/initializer'
require 'dry/types'

module SpyAlleyApplication
  class ChangeOrders
    extend Dry::Initializer
    option :first, optional: true, reader: :private
    option :rest, optional: true, reader: :private

    def changes
      (Array(first) + Array(rest&.changes)).freeze
    end

    def push(node)
      SpyAlleyApplication::ChangeOrders::new(first: node, rest: self)
    end

    def inspect
      "#<SpyAlleyApplicaton::ChangeOrders @changes=\r\n#{changes.map(&:inspect).join("\r\n")}>"
    end
    alias_method :to_s, :inspect

    def add_die_roll(player:, rolled:)
      action_hash = {}
      action_hash[:player_action] = 'roll'
      action_hash[:rolled]        = rolled

      push(
        DieRoll.new(
          player: player,
          rolled: rolled
        )
      ).push(ActionHashElement.new(action_hash: action_hash))
    end

    def add_admin_die_roll(player:, result_chosen:)
      action_hash = {}
      action_hash[:player_action] = 'roll'
      action_hash[:rolled]        = result_chosen
      action_hash[:admin_set?]    = true

      push(
        AdminDieRoll.new(
          player:        player,
          result_chosen: result_chosen
        )
      ).push(ActionHashElement.new(action_hash: action_hash))
    end

    def add_use_move_card(player:, card_to_use:)
      action_hash = {
        player_action: 'use_move_card',
        card_to_use:   card_to_use
      }

      push(
        UseMoveCard.new(
          player: player,
          card_to_use: card_to_use
        )
      ).push(
        PlaceCardAtBottomOfMoveCardDeck.new(card: card_to_use)
      ).push(ActionHashElement.new(action_hash: action_hash))
    end

    def add_move_action(player:, space:)
      action_hash = {}
      action_hash[:player_action] = 'move'
      action_hash[:space]         = space

      push(
        MoveAction.new(
          player: player,
          space_to_move: space
        )
      ).push(ActionHashElement.new(action_hash: action_hash))
    end

    def add_money_action(player:, amount:, reason:)
      action_hash = {}
      action_hash[:result] ||= {}
      action_hash[:result][:collect] = "$#{amount} for #{reason}"

      push(
        AddMoney.new(
          player: player,
          amount: amount
        )
      ).push(ActionHashElement.new(action_hash: action_hash))
    end

    def subtract_money_action(player:, amount:, paid_to:)
      push(
        SubtractMoney.new(
          player: player,
          amount: amount
        )
      )
    end

    def add_pass_action
      action_hash = {}
      action_hash[:player_action] = 'pass'

      push(ActionHashElement.new(action_hash: action_hash))
    end

    def add_equipment_action(player:, equipment:)
      push(
        AddEquipment.new(
          player: player,
          equipment: equipment
        )
      )
    end

    def add_action(action_to_add_as_hash)
      action_hash = {}
      if action_to_add_as_hash.has_key?(:result) && action_to_add_as_hash.is_a?(Hash)
        action_hash[:result] ||= {}
        action_hash[:result].merge!(action_to_add_as_hash[:result])
      end
      action_hash.merge!(action_to_add_as_hash.reject{|k, v| k.eql?(:result)})

      push(ActionHashElement.new(action_hash: action_hash))
    end

    def subtract_equipment_action(player:, equipment:)
      push(
        SubtractEquipment.new(
          player: player,
          equipment: equipment
        )
      )
    end

    def eliminate_player_action(player:)
      push(EliminatePlayer.new(player: player))
    end

    def add_wild_card_action(player:)
      push(AddWildCard::new(player: player))
    end

    def subtract_wild_card_action(player:)
      push(SubtractWildCard::new(player: player))
    end

    def add_move_options(options:)
      push(
        NextActionOptions::new(
          option: {move: {space: options}}
        )
      )
    end

    def add_buy_equipment_option(equipment:, limit:)
      push(NextActionOptions::new(option: {pass: true})).push(
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

    def add_draw_top_move_card(player:, top_move_card:)
      push(DrawTopMoveCard::new).push(AddMoveCard::new(player: player, card_to_add: top_move_card))
    end

    def add_draw_top_free_gift_card(player:, top_free_gift_card:)
      draw_top_gift_card = push(DrawTopFreeGiftCard::new)
      if top_free_gift_card.eql?('wild card')
        draw_top_gift_card.add_wild_card_action(player: player)
      else
        draw_top_gift_card.push(PlaceCardAtBottomOfFreeGiftCardDeck::new(card: top_free_gift_card))
      end
    end

    def add_spy_eliminator_option(options:)
      push(SpyEliminatorOption::new(options: options))
    end

    def add_game_victory(player:, reason:)
      push(GameVictory::new(player: player, reason: reason))
    end

    def add_confiscate_materials_option(options:)
      push(ConfiscateMaterialsOption::new(options: options))
    end

    def add_move_back_two_spaces_result
      push(MoveBackTwoSpaces::new)
    end

    def add_choose_new_spy_identity_option(options:, return_player:)
      push(ChooseNewSpyIdentityOption::new(options:options, return_player: return_player))
    end

    def add_next_player_up(seat:)
      push(NextPlayerUp::new(seat: seat))
    end

    def add_top_level_options(options={})
      push(TopLevelOptions::new(options))
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

    class DrawTopFreeGiftCard
    end

    class PlaceCardAtBottomOfFreeGiftCardDeck
      all_cards = %w(french german spanish italian american russian).map do |nationality|
        %w(password disguise codebook key).map{|equipment| "#{nationality} #{equipment}"}
      end.flatten

      extend Dry::Initializer
      option :card, type: Dry::Types['strict.string'].constrained(included_in: all_cards)
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

    class GameVictory
      extend Dry::Initializer
      option :player, type: Dry::Types['strict.hash']
      option :reason, type: Dry::Types['strict.string']
    end

    class SpyEliminatorOption
      extend Dry::Initializer
      option :options, type: Dry::Types['strict.array'].of(
        Dry::Types['strict.string'].constrained(included_in: (1..6).map{|seat| "seat_#{seat}"})
      )
    end

    class ConfiscateMaterialsOption
      extend Dry::Initializer
      option :options, type: Dry::Types['strict.hash']
    end

    class MoveBackTwoSpaces
    end

    class ChooseNewSpyIdentityOption
      extend Dry::Initializer
      nationalities = %w(french german spanish italian american russian)
      option :options, type: Dry::Types['strict.array'].of(
        Dry::Types['strict.string'].constrained(included_in: nationalities)
      ).constrained(size: 2)
      option :return_player,
        type: Dry::Types['strict.string'].constrained(included_in: (1..6).map{|seat| "seat_#{seat}"})
    end

    class NextPlayerUp
      extend Dry::Initializer
      option :seat, type: Dry::Types['strict.integer'].constrained(included_in: (1..6))
    end

    class TopLevelOptions
      extend Dry::Initializer
      option :accept_roll
      option :accept_make_accusation, type: Dry::Types['strict.hash']
      option :accept_use_move_card, optional: true, type: Dry::Types['strict.array'].of(
        Dry::Types['strict.integer'].constrained(included_in: (1..6))
      )
    end
  end
end

