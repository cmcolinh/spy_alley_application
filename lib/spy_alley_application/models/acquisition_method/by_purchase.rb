# frozen string literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Models
    module AcquisitionMethod
      class ByPurchase < Dry::Struct
        @@can_handle_by_purchase = ::Types.Interface(:handle_by_purchase)
        attribute :name, ::Types.Value('by_purchase')
        attribute :amount_paid, ::Types::CoercibleNonnegativeInteger

        def accept(visitor, **args)
          @can_handle_by_purchase.(visitor)
          visitor.handle_by_purchase(self, args)
        end
      end
    end
  end
end

