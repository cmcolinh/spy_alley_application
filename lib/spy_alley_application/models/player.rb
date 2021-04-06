# frozen string literal: true

require 'dry-struct'
require 'spy_alley_application/types/array_of_equipment'
require 'spy_alley_application/types/array_of_move_cards'
require 'spy_alley_application/types/board_space'
require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  module Models
    class Player < Dry::Struct::Value
      attribute :id, ::Types::Coercible::Integer
      attribute :seat, ::Types::Coercible::Integer
      attribute :location, SpyAlleyApplication::Types::BoardSpace
      attribute :spy_identity, SpyAlleyApplication::Types::Nationality
      attribute :money, ::Types::CoercibleNonnegativeInteger
      attribute :move_cards, SpyAlleyApplication::Types::ArrayOfMoveCards
      attribute :equipment, SpyAlleyApplication::Types::ArrayOfEquipment
      attribute :wild_cards, ::Types::CoercibleNonnegativeInteger
      attribute :active, ::Types::Strict::Bool
      alias_method :active?, :active

      def to_h
        location_id = location.id
        super.map do |k, v|
          [k.eql?(:active) ? :active? : k]
            .push(k.eql?(:location) ? {id: location_id} : v)
        end.to_h
      end

      def in_spy_alley?
        location.in_spy_alley?
      end
    end
  end
end

