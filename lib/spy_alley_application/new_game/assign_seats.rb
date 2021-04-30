# frozen string literal: true

module SpyAlleyApplication
  class NewGame
    class AssignSeats
      def call(seat_assignments)
        seat_assignments = seat_assignments.to_a
        seats = [1, 2, 3, 4, 5, 6] - (seat_assignments.map{|s| s[:seat]}.reject(&:nil?))
        seat_assignments.each do |seat|
          if seat[:seat].nil?
            index = rand(seats.size)
            seat[:seat] = seats[index]
            seats = seats - [seats[index]]
          end
        end
        seat_assignments
      end
    end
  end
end

