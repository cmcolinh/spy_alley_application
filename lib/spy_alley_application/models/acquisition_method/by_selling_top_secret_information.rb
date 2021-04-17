# frozen string literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Models
    module AcquisitionMethod
      class BySellingTopSecretInformation < Dry::Struct
        @@can_handle_by_selling_top_secret_information =
          ::Types.Interface(:handle_by_selling_top_secret_information)
        attribute :name, ::Types.Value('by_selling_top_secret_information')

        def accept(visitor, **args)
          @can_handle_by_selling_top_secret_information.(visitor)
          visitor.handle_by_selling_top_secret_information(self, args)
        end
      end
    end
  end
end

