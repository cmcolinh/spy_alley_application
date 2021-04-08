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
      class BlackMarketOptionState
        include Dry::Initializer.define -> do
          option :next_game_state, type: ::Types::Callable, reader: :private
          option :equipment_cost,
            default: ->{{password: 1, disguise: 5, codebook: 15, key: 30}},
            reader: :private,
            type: ::Types::Hash.schema(
              password: ::Types::CoercibleNonnegativeInteger,
              disguise: ::Types::CoercibleNonnegativeInteger,
              codebook: ::Types::CoercibleNonnegativeInteger,
              key: ::Types::CoercibleNonnegativeInteger)
        end

        def call(game_board:)
          player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
          affordable_equipment = SpyAlleyApplication::Types::EquipmentType.values.map do |t|
            player.money >= equipment_cost[t.to_sym]
          end

          equipment = affordable_equipment.map do |equipment_type|
            SpyAlleyApplication::Types::Nationality.values.map do |nationality|
              SpyAlleyApplication::Types::Equipment.call("#{nationality} #{equipment_type}")
            end
          end.flatten.sort.freeze

          options = player.equipment - equipment

          # only give buy option if player both has enough money and does not already all equipment
          if options.empty?
            return next_game_state.(game_board: game_board)
          end
          SpyAlleyApplication::Models::GameBoard::new(
            players: game_board.players,
            move_card_pile: game_board.move_card_pile,
            free_gift_pile: game_board.free_gift_pile,
            game_state: SpyAlleyApplication::Types::GameState.call(
              name: 'buy_equipment',
              seat: game_board.game_state.seat,
              options: options,
              limit: 1))
        end
      end
    end
  end
end

