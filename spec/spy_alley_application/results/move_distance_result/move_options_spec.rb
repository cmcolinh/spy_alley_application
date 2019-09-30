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
          it "correctly moves to space '#{location + distance}' when moving #{distance} spaces" do
            expect(
              move_options_for.(location: location, move_distance: distance)
            ).to match_array(["#{location + distance}"])
          end
        end
      end
    end
  end
  describe 'first three spaces of spy alley are straightforward, since player is guaranteed to remain in spy alley' do
    (1..3).to_a.each do |location|
      describe "from location '#{location}s'" do
        (1..6).each do |distance|
          it "correctly moves to space '#{location + distance}s' when moving #{distance} spaces" do
            expect(
              move_options_for.(location: location, move_distance: distance)
            ).to match_array(["#{location + distance}s"])
          end
        end
      end
    end
  end
  describe "from location '14' the player will be forced to enter spy alley" do
    (1..6).each do |distance|
      it "correctly moves to space '#{distance}s' when moving #{distance} spaces" do
        expect(
          move_options_for.(location: '14', move_distance: distance)
        ).to match_array(["#{distance}s"])
      end
    end
  end
  describe "between spaces '9' and '13' the player will have two options " +
    "if the location plus the distance are > 15" do

    (9..13).to_a.each do |location|
      describe "from location '#{location}'" do
        (1..(14 - location)).each do |distance|
          it "correctly gives one option at location '#{location + distance}' when moving #{distance} spaces" do
            expect(
              move_options_for.(location: '#{location}', move_distance: distance)
            ).to match_array(["#{location + distance}"])
          end
        end
        ((15 - location)..6).each do |distance|
          it "correctly gives two options, one at '#{location + distance}', " +
            "and one at '#{location + distance - 14}s' when moving #{distance} spaces" do

            expect(
              move_options_for.(location: '#{location}', move_distance: distance)
            ).to match_array(["#{location + distance}", "#{location + distance - 14}s"])
          end
        end
      end
    end
  end
end
