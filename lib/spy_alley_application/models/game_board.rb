# frozen string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/array_of_players'
require 'spy_alley_application/types/array_of_free_gifts'
require 'spy_alley_application/types/array_of_move_cards'
require 'spy_alley_application/types/game_state'

module SpyAlleyApplication
  module Models
    class GameBoard < Dry::Struct
      attribute :players, Types::ArrayOfPlayers
      attribute :move_card_pile, Types::ArrayOfMoveCards
      attribute :free_gift_pile, Types::ArrayOfFreeGifts
      attribute :game_state, Types::GameState
    end
  end
end

