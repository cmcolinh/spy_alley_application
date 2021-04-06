# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/models/game_board'

module SpyAlleyApplication
  module Results
    module Nodes
      class ResultGameBoardNode < Dry::Struct
        @@can_handle_result_game_board = ::Types.Interface(:handle_result_game_board)
        attribute :game_board, SpyAlleyApplication::Models::GameBoard

        def accept(visitor, **args)
          @@can_handle_result_game_board.(visitor)
          visitor.handle_result_game_board(self, args)
        end
      end
    end
  end
end

