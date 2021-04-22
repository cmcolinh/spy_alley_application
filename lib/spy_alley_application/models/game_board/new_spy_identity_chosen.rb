# frozen string_literal: true

require 'dry-initializer'
require 'dry-struct'
require 'spy_alley_application/types/game_board'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      class NewSpyIdentityChosen
        def call(game_board:, new_spy_identity:)
          player = game_board.current_player
          if !player.spy_identity.eql?(new_spy_identity)
            eliminated_player = game_board.players.find{|p| p.spy_identity.eql?(new_spy_identity)}
            puts eliminated_player
            unaffected_players = game_board
              .players
              .reject{|p| [player, eliminated_player].include?(p)}

            eliminated_player =
              eliminated_player.to_h.tap{|p| p[:spy_identity] = player.spy_identity}
            player = player.to_h.tap{|p| p[:spy_identity] = new_spy_identity}

            players = unaffected_players
            players.push(player)
            players.push(eliminated_player)
            players = players.sort_by{|p| p[:seat]}

            game_board = SpyAlleyApplication::Types::GameBoard.call(
              game_board.to_h.tap{|b| b[:players] = players})
          end
          game_board
        end
      end
    end
  end
end

