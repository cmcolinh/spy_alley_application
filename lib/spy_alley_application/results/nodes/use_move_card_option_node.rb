# frozen_string_literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Results
    module Nodes
      class UseMoveCardOptionNode < Dry::Struct
        @@can_handle_use_move_card = ::Types.Interface(:handle_use_move_card)
        attribute :card_list, ::Types::ArrayOfStrictInteger

        def accept(visitor, **args)
          @@can_handle_use_move_card.(visitor)
          visitor.handle_use_move_card(self, args)
        end
      end
    end
  end
end

