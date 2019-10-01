# frozen_string_literal: true

module SpyAlleyApplication
  module Results
    class MoveDistanceResult
      class MoveOptions
        @@board_nodes = (
          ((0..13).to_a + (14..22).to_a).map{|space| ["#{space}", "#{space + 1}"]} +
          (1..8).map{|space| ["#{space}s", "#{space + 1}s"]} +
          [['14', ['15', '1s']], ['9s', '22'], ['23', '0'], ['s14', '1s']]
        ).to_h

        def call(location:, move_distance:)
          location = 's14' if location.eql?('14')
          move_spaces = Array(location)
          move_distance.times do
            move_spaces = Array(move_spaces.map{|space| @@board_nodes[space]}).flatten
          end
          move_spaces
        end
      end
    end
  end
end
