# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Validator::RollNoMoveCardValidator do
  let(:validate){
    SpyAlleyApplication::Validator::RollNoMoveCardValidator::new(
      roll_options:            nil,
      accusation_targets:      ['seat_2', 'seat_3'],
      accusable_nationalities: %w(french german spanish italian american russian)
    )
  }
  describe '#call' do
    describe 'choosing to roll' do
      it 'will validate correctly when simply choosing to roll' do
        expect(validate.(player_action: 'roll')).to be_success
      end

      it 'will fail if you choose to roll, and then choose a target for an accusation' do
        expect(
          validate.(
            player_action: 'roll',
            player_to_accuse: 'seat_2',
            nationality: 'french'
          )
        ).to be_failure
      end
    end
  end
end
