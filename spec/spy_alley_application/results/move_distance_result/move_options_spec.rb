# frozen_string_literal: true

require 'spy_alley_application/results/move_distance_result/move_options'

RSpec.describe SpyAlleyApplication::Results::MoveDistanceResult::MoveOptions do
  let(:move_options_for) do
    SpyAlleyApplication::Results::MoveDistanceResult::MoveOptions::new
  end
  describe "first nine spaces on the board, as well as squares '15', '16', and '17' are straightforward" do
    (0..8).to_a + (15..17).to_a.each do |location|
      describe "from location '#{location}'" do
        (1..6).each do |distance|
          it "correctly moves to space #{location + distance} when moving #{distance} spaces" do
            expect(
              move_options_for.(location: location, move_distance: move_distance))
              .to match_array(["#{location + distance}"]
            )
          end
        end
      end
    end
  end
end

