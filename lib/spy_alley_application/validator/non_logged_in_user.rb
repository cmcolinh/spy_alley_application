# frozen_string_literal: true

module SpyAlleyApplication
  class Validator
    class NonLoggedInUser
      def id
        nil
      end

      def admin?
        false
      end
    end
  end
end
