# frozen_string_literal: true

require 'dry-struct'
require 'spy_alley_application/types/coercible_integer_one_to_six'

module SpyAlleyApplication
  module Results
    module Nodes
      class DieRolledNode < Dry::Struct
        @@can_handle_die_rolled = ::Types.Interface(:handle_die_rolled)
        attribute :number_rolled, SpyAlleyApplication::Types::CoercibleIntegerOneToSix

        def accept(visitor, **args)
          @can_handle_die_rolled.(visitor)
          visitor.handle_die_rolled(self, args)
        end
      end
    end
  end
end

