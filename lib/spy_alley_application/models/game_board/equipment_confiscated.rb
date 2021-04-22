# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class EquipmentConfiscated
        include Dry::Initializer.define -> do
          option :equipment_cost,
            default: ->{{password: 5, disguise: 5, codebook: 10, key: 25, wild_card: 50}},
            reader: :private,
            type: ::Types::Hash.schema(
              password: ::Types::CoercibleNonnegativeInteger,
              disguise: ::Types::CoercibleNonnegativeInteger,
              codebook: ::Types::CoercibleNonnegativeInteger,
              key: ::Types::CoercibleNonnegativeInteger,
              wild_card: ::Types::CoercibleNonnegativeInteger)
        end

        def call(game_board:, target_player:, equipment:)
          player = game_board.current_player
          unaffected_players = game_board
            .players
            .reject{|player| [player, target_player].include?(player)}
          wild_card = equipment.accept(self).eql?(:wild_card)
          cost = equipment_cost[equipment.accept(self)]

          player_equipment = player.equipment.map(&:itself)
          player_equipment = (player_equipment + [equipment]).sort unless wild_card
          target_equipment = target_player.equipment.map(&:itself)
          target_equipment = (target_equipment - [equipment]).sort unless wild_card

          player = player.to_h
          player[:money] -= cost
          player[:equipment] = player_equipment.freeze
          player[:wild_cards] += 1 if wild_card

          target = target_player.to_h
          target[:money] += cost
          target[:equipment] = target_equipment.freeze
          target[:wild_cards] -= 1 if wild_card

          players = unaffected_players
            .push(player)
            .push(target)
            .sort_by{|p| p[:seat]}
            .freeze

          SpyAlleyApplication::Types::GameBoard.call(
            game_board.to_h.tap{|g| g[:players] = players})
        end

        def handle_equipment(equipment, **args)
          equipment.type.to_sym
        end

        def handle_wild_card(*args)
          :wild_card
        end
      end
    end
  end
end

