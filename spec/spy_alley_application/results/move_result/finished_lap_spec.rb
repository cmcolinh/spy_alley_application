# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::MoveResult::FinishedLap do
  let(:finished_lap) do
    SpyAlleyApplication::Results::MoveResult::FinishedLap::new
  end
  describe '#call' do
    it 'correctly concludes that it is not a new lap if both start and end points are early in lap' do
      expect(
        finished_lap.(previous_location: '0', space_to_move: '3')
      ).to be false
    end

    it 'correctly concludes that it is not a new lap if start is early and end is mid-lap' do
      expect(
        finished_lap.(previous_location: '8', space_to_move: '11')
      ).to be false
    end

    it 'correctly concludes that it is not a new lap if start is early lap and end is in spy alley' do
      expect(
        finished_lap.(previous_location: '9', space_to_move: '1s')
      ).to be false
    end

    it 'correctly concludes that it is not a new lap if start is mid lap and end is in spy alley' do
      expect(
        finished_lap.(previous_location: '13', space_to_move: '3s')
      ).to be false
    end

    it 'correctly concludes that it is not a new lap if start is mid lap and end is late lap' do
      expect(
        finished_lap.(previous_location: '18', space_to_move: '23')
      ).to be false
    end

    it 'correctly concludes that it is not a new lap if start and end are both in spy alley' do
      expect(
        finished_lap.(previous_location: '3s', space_to_move: '7s')
      ).to be false
    end

    it 'correctly concludes that it is not a new lap if start and end are both mid lap' do
      expect(
        finished_lap.(previous_location: '13', space_to_move: '15')
      ).to be false
    end

    it 'correctly concludes that it is not a new lap if start and end are both late lap' do
      expect(
        finished_lap.(previous_location: '20', space_to_move: '23')
      ).to be false
    end

    it 'correctly concludes that it is not a new lap if start is in spy alley and the end is late lap' do
      expect(
        finished_lap.(previous_location: '7s', space_to_move: '23')
      ).to be false
    end

    it 'correctly concludes that it is a new lap if start is in spy alley and the end is early lap' do
      expect(
        finished_lap.(previous_location: '7s', space_to_move: '1')
      ).to be true
    end

    it 'correctly concludes that it is a new lap if start is in spy alley and the end is the start space' do
      expect(
        finished_lap.(previous_location: '7s', space_to_move: '0')
      ).to be true
    end

    it 'correctly concludes that it is a new lap if start is mid-lap and the end is early lap' do
      expect(
        finished_lap.(previous_location: '19', space_to_move: '1')
      ).to be true
    end

    it 'correctly concludes that it is a new lap if start is mid-lap and the end is the start space' do
      expect(
        finished_lap.(previous_location: '18', space_to_move: '0')
      ).to be true
    end

    it 'correctly concludes that it is a new lap if start is mid-lap and the end is early lap' do
      expect(
        finished_lap.(previous_location: '19', space_to_move: '1')
      ).to be true
    end

    it 'correctly concludes that it is a new lap if start is mid-lap and the end is the start space' do
      expect(
        finished_lap.(previous_location: '18', space_to_move: '0')
      ).to be true
    end

    it 'correctly concludes that it is a new lap if start is late-lap and the end is early lap' do
      expect(
        finished_lap.(previous_location: '21', space_to_move: '2')
      ).to be true
    end

    it 'correctly concludes that it is a new lap if start is late-lap and the end is the start space' do
      expect(
        finished_lap.(previous_location: '23', space_to_move: '0')
      ).to be true
    end
  end
end

