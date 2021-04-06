# frozen_string_literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Results
    module Nodes
      class MakeAccusationOptionNode < Dry::Struct
        @@can_handle_make_accusation_option = ::Types.Interface(:handle_make_accusation_option)
        attribute :player_id_list, ::Types::ArrayOfStrictInteger

        def accept(visitor, **args)
          @can_handle_make_accusation_option.(visitor)
          visitor.handle_make_accusation_option(self, args)
        end
      end
    end
  end
end

