# frozen string literal: true

module SpyAlleyApplication
  module Models
    class WildCard
      @@can_handle_wild_cards = ::Types.Interface(:handle_wild_card)

      def accept(visitor, **args)
        @@can_handle_wild_cards.(visitor)
        visitor.handle_wild_card(self, args)
      end

      def inspect
        'wild card'
      end
      alias_method :to_s, :inspect
      alias_method :to_h, :to_s
    end
  end
end

