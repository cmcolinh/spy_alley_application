# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Results
    module Nodes
      class NewSpyIdentityChosenNode < Dry::Struct
        @@can_handle_move_option = ::Types.Interface(:handle_new_spy_identity_chosen)
        attribute :nationality, SpyAlleyApplication::Types::Nationality

        def accept(visitor, **args)
          @can_handle_new_spy_identity_chosen.(visitor)
          visitor.handle_new_spy_identity_chosen(self, args)
        end
      end
    end
  end
end

