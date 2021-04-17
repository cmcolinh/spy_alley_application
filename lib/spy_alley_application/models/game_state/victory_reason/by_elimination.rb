# frozen string literal: true

require 'dry-struct'

module SpyAlleyApplication
  module Models
    module GameState
      module VictoryReason
        class ByElimination < Dry::Struct
          @@can_handle_by_elimination = ::Types.Interface(:handle_by_elimination)
          attribute :name, ::Types.Value('by_elimination')

          def accept(visitor, **args)
            @can_handle_by_elimination.(visitor)
            visitor.handle_by_elimination(self, args)
          end
        end
      end
    end
  end
end

