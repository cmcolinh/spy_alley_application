# frozen string literal: true

require 'dry-struct'
require 'spy_alley_application/types/equipment_type'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Models
    class Equipment < Dry::Struct
      @@can_handle_equipment = ::Types.Interface(:handle_equipment)

      attribute :nationality, SpyAlleyApplication::Types::Nationality
      attribute :type, SpyAlleyApplication::Types::EquipmentType

      def accept(visitor, **args)
        @@can_handle_equipment.(visitor)
        visitor.handle_equipment(self, args)
      end

      def wild_card?
        false
      end

      def to_h
        self
      end

      def to_s
        "#{nationality} #{type}"
      end
      alias_method :transform_values, :to_s

      def <=>(other)
        return nil if !other.is_a?(self.class)
        result = self.nationality <=> other.nationality
        result = self.type <=> other.type if result.eql?(0)
        result
      end
    end
  end
end

