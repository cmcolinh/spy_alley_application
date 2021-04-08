# frozen string literal: true

require 'dry-struct'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Models
    module GameState
      class GameOver < Dry::Struct
        @@can_handle_game_over = ::Types.Interface(:handle_game_over)

        attribute :name, ::Types::Value('game_over')
        attribute :type, ::Types::String::enum('by_elimination', 'by_embassy')
        attribute :seat, SpyAlleyApplication::Types::CoercibleIntegerOneToSix

        def accept(visitor, **args)
          @@can_handle_game_over.(visitor)
          visitor.handle_game_over(self, args)
        end
      end
    end
  end
end

