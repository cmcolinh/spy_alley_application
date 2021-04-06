# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    module Nodes
      class RollDieOptionNode
        @@can_handle_pass_option = ::Types.Interface(:handle_pass_option)
        def accept(visitor, **args)
          @@can_handle_pass_option.(visitor)
          visitor.handle_pass_option(self, args)
        end
      end
    end
  end
end

