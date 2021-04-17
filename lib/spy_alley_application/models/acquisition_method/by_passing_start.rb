# frozen string literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Models
    module AcquisitionMethod
      class ByPassingStart < Dry::Struct
        @@can_handle_by_passing_start = ::Types.Interface(:handle_by_passing_start)
        attribute :name, ::Types.Value('by_passing_start')

        def accept(visitor, **args)
          @can_handle_by_passing_start.(visitor)
          visitor.handle_by_passing_start(self, args)
        end
      end
    end
  end
end

