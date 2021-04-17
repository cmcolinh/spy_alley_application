# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/models/game_board'
require 'spy_alley_application/types/equipment'
require 'spy_alley_application/types/equipment_type'
require 'spy_alley_application/types/game_state'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class ConfiscateMaterialsOptionState
        include Dry::Initializer.define -> do
          option :next_game_state, type: ::Types::Callable, reader: :private
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

        def call(game_board:)
          player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
          other_players = game_board.players.reject{|p| p.seat.eql?(game_board.game_state.seat)}

          affordable_types = SpyAlleyApplication::Types::EquipmentType.values.select do |t|
            player.money >= equipment_cost[t.to_sym]
          end
          can_afford_wild_card = (player.money > equipment_cost[:wild_card])

          all_affordable_equipment = affordable_types.map do |equipment_type|
            SpyAlleyApplication::Types::Nationality.values.map do |nationality|
              SpyAlleyApplication::Types::Equipment.call("#{nationality} #{equipment_type}")
            end
          end.flatten.sort

          targets = other_players.map do |p|
            equipment = all_affordable_equipment.select{|e| p.equipment.include?(e)}
            equipment.push('wild card') if p.wild_cards > 0 && can_afford_wild_card
            [p.seat, equipment.freeze]
          end.reject{|seat, equipment| equipment.empty?}.map do |seat, equipment|
            {seat: seat, equipment: equipment}
          end.freeze

          # only give confiscation option if there are targets
          if targets.empty?
            return next_game_state.(game_board: game_board)
          end
          SpyAlleyApplication::Models::GameBoard::new(
            players: game_board.players,
            move_card_pile: game_board.move_card_pile,
            free_gift_pile: game_board.free_gift_pile,
            game_state: SpyAlleyApplication::Types::GameState.call(
              name: 'confiscate_materials',
              seat: game_board.game_state.seat,
              targets: targets))
        end
      end
    end
  end
end

