# frozen_string_literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Results
    module Nodes
      class NextPlayerNode < Dry::Struct
        @@can_handle_next_player = ::Types.Interface(:handle_next_player)
        attribute :player_id, ::Types::Strict::Integer

        def accept(visitor, **args)
          @@can_handle_next_player.(visitor)
          visitor.handle_next_player(self, args)
        end
      end
    end
  end
end

