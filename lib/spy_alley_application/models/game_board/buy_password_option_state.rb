# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/models/game_board'
require 'spy_alley_application/types/equipment'
require 'spy_alley_application/types/game_state'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class BuyPasswordOptionState
        include Dry::Initializer.define -> do
          option :next_game_state, type: ::Types::Callable, reader: :private
          option :password_cost, type: ::Types::CoercibleNonnegativeInteger, reader: private,
            default: ->{1}
        end

        def call(game_board:, nationality:)
          equipment_to_add = SpyAlleyApplication::Types::Equipment.call("#{nationality} password")
          player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
          # only give buy option if player both has money and does not already have the password
          if player.money < password_cost || player.equipment.any?{|e| e.eql?(equipment_to_add)}
            return next_game_state.(game_board: game_board)
          end
          SpyAlleyApplication::Models::GameBoard::new(
            players: game_board.players,
            move_card_pile: game_board.move_card_pile,
            free_gift_pile: game_board.free_gift_pile,
            game_state: SpyAlleyApplication::Types::GameState.call(
              name: 'buy_equipment',
              seat: game_board.game_state.seat,
              options: [equipment_to_add],
              limit: 1))
        end
      end
    end
  end
end

