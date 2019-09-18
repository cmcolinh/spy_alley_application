# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Validator::SpyEliminatorValidator do
  describe '#call' do
    let(:validate){
      SpyAlleyApplication::Validator::SpyEliminatorValidator::new(
        accusation_targets:      ['seat_2', 'seat_3'],
        accusable_nationalities: %w(french german spanish italian american russian)
      )
    }
    describe 'choosing to pass' do
      it 'will validate correctly when simply choosing to pass' do
        expect(validate.(player_action: 'pass')).to be_success
      end

      it 'will fail if you choose to pass, and then choose a target for an accusation' do
        expect(
          validate.(
            player_action: 'pass',
            player_to_accuse: 'seat_2',
            nationality: 'french'
          )
        ).to be_failure
      end

      it 'will fail if you choose to pass, and player_to_accuse is set' do
        expect(validate.(player_action: 'pass', player_to_accuse: 'seat_2')).to be_failure
      end

      it 'will fail if you choose to pass, and nationality is set' do
        expect(validate.(player_action: 'pass', nationality: 'french')).to be_failure
      end
    end

    describe 'choosing to make accusation' do
      it 'will successfully validate an accusation with valid seats and nationalities' do
        expect(
          validate.(
            player_action:    'make_accusation',
            player_to_accuse: 'seat_2',
            nationality:      'french'
          )
        ).to be_success
      end

      it 'will fail if you choose an invalid player' do
        expect(
          validate.(
            player_action:    'make_accusation',
            player_to_accuse: 'invalid_seat',
            nationality:      'french'
          )
        ).to be_failure
      end

      it 'will fail if you choose an invalid nationality' do
        expect(
          validate.(
            player_action:    'make_accusation',
            player_to_accuse: 'seat_2',
            nationality:      'invalid_nationality'
          )
        ).to be_failure
      end

      it 'will fail if you do not select a player to accuse' do
        expect(
          validate.(
            player_action:    'make_accusation',
            nationality:      'french'
          )
        ).to be_failure
      end

      it 'will fail if you do not select a nationality to accuse the player of being' do
        expect(
          validate.(
            player_action:    'make_accusation',
            player_to_accuse: 'french'
          )
        ).to be_failure
      end
    end

    describe 'invalid player action' do
      it 'will fail if an invalid action is specified' do
        expect(validate.(player_action: 'roll')).to be_failure
      end
      it 'will fail if no player action is specified' do
        expect(validate.(player_to_accuse: 'seat_2', nationality: 'french')).to be_failure
      end
    end
  end
end
