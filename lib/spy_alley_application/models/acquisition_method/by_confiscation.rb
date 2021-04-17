# frozen string literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Models
    module AcquisitionMethod
      class ByConfiscation < Dry::Struct
        @@can_handle_by_confiscation = ::Types.Interface(:handle_by_confiscation)
        attribute :name, ::Types.Value('by_confiscation')
        attribute :target_player_id, ::Types::Coercible::Integer
        attribute :amount_paid, ::Types::CoercibleNonnegativeInteger

        def accept(visitor, **args)
          @can_handle_by_confiscation.(visitor)
          visitor.handle_by_confiscation(self, args)
        end
      end
    end
  end
end

