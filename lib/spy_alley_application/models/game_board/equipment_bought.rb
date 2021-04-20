# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/types/equipment'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class EquipmentBought
        include Dry::Initializer.define -> do
          option :next_game_state, type: ::Types::Callable, reader: :private
          option :equipment_cost,
            default: ->{{password: 1, disguise: 5, codebook: 15, key: 30}},
            type: ::Types::Hash.schema(
              password: ::Types::CoercibleNonnegativeInteger,
              disguise: ::Types::CoercibleNonnegativeInteger,
              codebook: ::Types::CoercibleNonnegativeInteger,
              key: ::Types::CoercibleNonnegativeInteger)
        end

        def call(game_board:, equipment_bought:)
          player = game_board.current_player
          total_cost = 0
          equipment_bought = equipment_bought
            .map{|equipment| SpyAlleyApplication::Types::Equipment.call(equipment)}
          equipment_bought.each{|equipment| total_cost += equipment_cost[equipment.type.to_sym]}

          unaffected_players = game_board.players.reject{|p| p.equal?(player)}
          player = player.to_h.tap do |p|
            p[:equipment] = (p[:equipment] + equipment_bought).sort
            p[:money] = p[:money] - total_cost
          end
          players = unaffected_players.push(player).sort_by{|p| p[:seat]}
          game_board = SpyAlleyApplication::Types::GameBoard.call(
            game_board.to_h.tap{|g| g[:players] = players})
          next_game_state.(game_board: game_board)
        end
      end
    end
  end
end

