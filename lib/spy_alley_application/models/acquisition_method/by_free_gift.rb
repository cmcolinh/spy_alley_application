# frozen string literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Models
    module AcquisitionMethod
      class ByFreeGift < Dry::Struct
        @@can_handle_by_free_gift = ::Types.Interface(:handle_by_free_gift)
        attribute :name, ::Types.Value('by_free_gift')

        def accept(visitor, **args)
          @can_handle_by_free_gift.(visitor)
          visitor.handle_by_free_gift(self, args)
        end
      end
    end
  end
end

