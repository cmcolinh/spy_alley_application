# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/models/game_board'
require 'spy_alley_application/types/equipment'
require 'spy_alley_application/types/game_state'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class BuyEquipmentOptionState
        include Dry::Initializer.define -> do
          option :next_game_state, type: ::Types::Callable, reader: :private
          option :equipment_cost,
            default: ->{{disguise: 5, codebook: 15, key: 30}},
            reader: :private,
            type: ::Types::Hash.schema(
              disguise: ::Types::CoercibleNonnegativeInteger,
              codebook: ::Types::CoercibleNonnegativeInteger,
              key: ::Types::CoercibleNonnegativeInteger)
        end

        def call(game_board:, equipment_type:)
          player = game_board.current_player
          unit_cost = equipment_cost[equipment_type.to_sym]
          equipment = SpyAlleyApplication::Types::Nationality.values.map do |nationality|
            SpyAlleyApplication::Types::Equipment.call("#{nationality} #{equipment_type}")
          end
          options = (equipment - player.equipment).sort.freeze
          limit = [player.money / unit_cost, options.length].min

          # only give buy option if player both has enough money and does not already all equipment
          if limit.eql?(0)
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
              limit: limit))
        end
      end
    end
  end
end

