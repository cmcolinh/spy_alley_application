# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/array_of_players'

module SpyAlleyApplication
  module Results
    module Nodes
      class MakeAccusationOptionNode < Dry::Struct
        @@can_handle_make_accusation_option = ::Types.Interface(:handle_make_accusation_option)
        attribute :player_list, SpyAlleyApplication::Types::ArrayOfPlayers

        def accept(visitor, **args)
          @@can_handle_make_accusation_option.(visitor)
          visitor.handle_make_accusation_option(self, args)
        end
      end
    end
  end
end

