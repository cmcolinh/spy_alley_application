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
              move_options_for.(location: "#{location}", move_distance: distance)
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
              move_options_for.(location: "#{location}s", move_distance: distance)
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
              move_options_for.(location: "#{location}", move_distance: distance)
            ).to match_array(["#{location + distance}"])
          end
        end
        ((15 - location)..6).each do |distance|
          it "correctly gives two options, one at '#{location + distance}', " +
            "and one at '#{location + distance - 14}s' when moving #{distance} spaces" do

            expect(
              move_options_for.(location: "#{location}", move_distance: distance)
            ).to match_array(["#{location + distance}", "#{location + distance - 14}s"])
          end
        end
      end
    end
  end
  describe "from location '23' the player will complete a lap" do
    (1..6).each do |distance|
      it "correctly moves to space '#{distance - 1}' when moving #{distance} spaces" do
        expect(
          move_options_for.(location: '23', move_distance: distance)
        ).to match_array(["#{distance - 1}"])
      end
    end
  end
  describe "between spaces '18' and '22' there is a chance that the move distance will pass start" do
    (18..22).to_a.each do |location|
      describe "from location '#{location}'" do
        (1..(23 - location)).each do |distance|
          it "correctly goes to location '#{location + distance}' " +
            "when moving #{distance} spaces, staying on the same lap" do

            expect(
              move_options_for.(location: "#{location}", move_distance: distance)
            ).to match_array(["#{location + distance}"])
          end
        end
        ((24 - location)..6).each do |distance|
          it "correctly goes to location '#{(location + distance) % 24}' " +
            "when moving #{distance} spaces, starting a new lap" do

            expect(
              move_options_for.(location: "#{location}", move_distance: distance)
            ).to match_array(["#{(location + distance) % 24}"])
          end
        end
      end
    end
  end
  describe "from locations '4s' and '5s' there is a chance to leave spy alley, but no chance to complete a lap" do
    (4..5).each do |location|
      describe "from location '#{location}'s" do
        (1..(9 - location)).each do |distance|
          it "correctly goes to location '#{location + distance}s' " +
            "when moving #{distance} spaces, staying in spy alley" do

            expect(
              move_options_for.(location: "#{location}s", move_distance: distance)
            ).to match_array(["#{location + distance}s"])
          end
        end
        ((10 - location)..6).each do |distance|
          it "correctly goes to location '#{location + distance + 12}' " +
            "when moving #{distance} spaces, leaving spy alley" do

            expect(
              move_options_for.(location: "#{location}s", move_distance: distance)
            ).to match_array(["#{location + distance + 12}"])
          end
        end
      end
    end
  end
  describe "from locations '6s', '7s', and '8s' the player may or may not leave spy alley, and may complete a lap" do
    (6..8).each do |location|
      describe "from location '#{location}'s" do
        (1..(9 - location)).each do |distance|
          it "correctly goes to location '#{location + distance}s' " +
            "when moving #{distance} spaces, staying in spy alley" do

            expect(
              move_options_for.(location: "#{location}s", move_distance: distance)
            ).to match_array(["#{location + distance}s"])
          end
        end
        ((10 - location)..(11 - location)).each do |distance|
          it "correctly goes to location '#{location + distance + 12}' " +
            "when moving #{distance} spaces, leaving spy alley, and staying on the same lap" do

            expect(
              move_options_for.(location: "#{location}s", move_distance: distance)
            ).to match_array(["#{location + distance + 12}"])
          end
        end
        ((12 - location)..6).each do |distance|
          it "correctly goes to location '#{(location + distance + 12) % 24}' " +
            "when moving #{distance} spaces, leaving spy alley, and starting a new lap" do

            expect(
              move_options_for.(location: "#{location}s", move_distance: distance)
            ).to match_array(["#{(location + distance + 12) % 24}"])
          end
        end
      end
    end
  end
  describe "from locations '9s' the player will leave spy alley, and may complete a lap" do
    (1..2).each do |distance|
      it "correctly goes to location '#{21 + distance}' " +
        "when moving #{distance} spaces, staying on the same lap" do

        expect(
          move_options_for.(location: '9s', move_distance: distance)
        ).to match_array(["#{21 + distance}"])
      end
    end
    (3..6).each do |distance|
      it "correctly goes to location '#{(21 + distance) % 24}' " +
        "when moving #{distance} spaces, starting a new lap" do

        expect(
          move_options_for.(location: '9s', move_distance: distance)
        ).to match_array(["#{(21 + distance) % 24}"])
      end
    end
  end
end
