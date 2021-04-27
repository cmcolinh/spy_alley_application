# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Results
    module Nodes
      class ChooseNewSpyIdentityOptionNode < Dry::Struct
        @@can_handle_choose_new_spy_identity_option =
          ::Types.Interface(:handle_choose_new_spy_identity_option)
        attribute :options, ::Types::Array.of(SpyAlleyApplication::Types::Nationality)
          .constrained(size: 2)
          
        def accept(visitor, **args)
          @can_handle_choose_new_spy_identity_option.(visitor)
          visitor.handle_choose_new_spy_identity_option(self, args)
        end
      end
    end
  end
end

