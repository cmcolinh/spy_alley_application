# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class EquipmentConfiscated
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

        def call(game_board:, target_player:, equipment:)
          player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
          unaffected_players = game_board
            .players
            .reject{|player| [player, target_player].include?(player)}
          cost = equipment_cost[:wild_card] if equipment.wild_card?
          cost = equipment_cost[:"#{equipment.type}"] if !equipment.wild_card?

          player = player.to_h
          player[:money] -= cost
          player[:equipment] = (player[:equipment] + [equipment]).sort if !equipment.wild_card?
          player[:wild_cards] += 1 if equipment.wild_card?

          target = target_player.to_h
          target[:money] += cost
          player[:equipment] = (player[:equipment] - [equipment]).sort if !equipment.wild_card?
          player[:wild_cards] -= 1 if equipment.wild_card?

          players = unaffected_players
            .push(player)
            .push(target)
            .sort{|p, q| p[:seat] <=> q[:seat]}
            .freeze

          game_board = SpyAlleyApplication::Models::GameBoard.call(
            game_board.to_h.tap{|g| g[:players] = players})

          next_game_state.(game_board: game_board)
        end
      end
    end
  end
end

