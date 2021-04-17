# frozen string literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Models
    module GameState
      module VictoryReason
        class ByEmbassy < Dry::Struct
          @@can_handle_by_embassy = ::Types.Interface(:handle_by_embassy)
          attribute :name, ::Types.Value('by_embassy')

          def accept(visitor, **args)
            @can_handle_by_embassy.(visitor)
            visitor.handle_by_embassy(self, args)
          end
        end
      end
    end
  end
end

