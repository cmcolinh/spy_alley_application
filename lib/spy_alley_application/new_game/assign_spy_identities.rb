# frozen string literal: true

require 'spy_alley_application/types/nationality'

module SpyAlleyApplication
  class NewGame
    class AssignSpyIdentities
      def call(seat_assignments)
        seat_assignments = seat_assignments.to_a
        spy_identities = SpyAlleyApplication::Types::Nationality.values -
          (seat_assignments.map{|s| s[:spy_identity]}.reject(&:nil?))
        seat_assignments.each do |seat|
          if seat[:spy_identity].nil?
            index = rand(spy_identities.size)
            seat[:spy_identity] = spy_identities[index]
            spy_identities = spy_identities - [spy_identities[index]]
          end
        end
        seat_assignments
      end
    end
  end
end

