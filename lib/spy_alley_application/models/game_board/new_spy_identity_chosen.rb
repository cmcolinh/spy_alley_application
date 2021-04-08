# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class NewSpyIdentityChosen
        include Dry::Initializer.define -> do
          option :next_game_state, type: ::Types::Callable, reader: :private
        end

        def call(game_board:, new_spy_identity:)
          player = game_board.players.find{|p| p.seat.eql?(game_board.game_state.seat)}
          if !player.spy_identity.eql?(new_spy_identity)
            unaffected_players = game_board
              .players
              .reject{|player| [eliminating_player, eliminated_player].include?(player)}

            eliminated_player = game_board.players.find{|p| p.spy_identity.eql?(new_spy_identity)}
            eliminated_player = SpyAlleyApplication::Types::Player.call(
              eliminated_player.to_h.tap{|p| p[:spy_identity] = player.spy_identity})
            player = SpyAlleyApplication::Types::Player.call(
              player.to_h.tap{|p| p[:spy_identity] = new_spy_identity})

            players = unaffected_players + [player, eliminated_player]
              .sort{|p, q| p.seat <=> q.seat}

            game_board = SpyAlleyApplication::Types::GameBoard.call(
              game_board.to_h.tap{|b| b[:players] = players})
          end
          next_game_state.(game_board: game_board)
        end
      end
    end
  end
end

