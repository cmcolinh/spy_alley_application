# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    module Nodes
      class PassOptionNode
        @@can_handle_roll_die_option = ::Types.Interface(:handle_roll_die_option)
        def accept(visitor, **args)
          @@can_handle_roll_die_option.(visitor)
          visitor.handle_roll_die_option(self, args)
        end
      end
    end
  end
end

