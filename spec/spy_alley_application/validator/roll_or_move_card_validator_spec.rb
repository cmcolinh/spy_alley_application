# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Validator::RollOrMoveCardValidator do
  describe '#call' do
    describe 'non-admin' do
      let(:validate){
        SpyAlleyApplication::Validator::RollOrMoveCardValidator::new(
          roll_options:            nil,
          accusation_targets:      ['seat_2', 'seat_3'],
          accusable_nationalities: %w(french german spanish italian american russian),
          move_card_options:       [1, 2, 3]
        )
      }
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

        it 'will fail if you choose to roll, and player_to_accuse is set' do
          expect(validate.(player_action: 'roll', player_to_accuse: 'seat_2')).to be_failure
        end

        it 'will fail if you choose to roll, and nationality is set' do
          expect(validate.(player_action: 'roll', nationality: 'french')).to be_failure
        end

        it 'will fail if you choose to roll, and card_to_use is set' do
          expect(validate.(player_action: 'roll', card_to_use: 1)).to be_failure
        end

        it 'will fail if you choose to roll and try to set the result without being an admin' do
          expect(validate.(player_action: 'roll', choose_result: 5)).to be_failure
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

        it 'will fail if you attempt to choose a result while making an accusation' do
          expect(
            validate.(
              player_action:    'make_accusation',
              player_to_accuse: 'seat_2',
              nationality:      'french',
              choose_result:    5
            )
          ).to be_failure
        end
      end
    end

    describe 'admin' do
      let(:validate){
        SpyAlleyApplication::Validator::RollOrMoveCardValidator::new(
          roll_options:            :permit_choose_result,
          accusation_targets:      ['seat_2', 'seat_3'],
          accusable_nationalities: %w(french german spanish italian american russian),
          move_card_options:       [1, 2, 3]
        )
      }
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

        it 'will fail if you choose to roll, and player_to_accuse is set' do
          expect(validate.(player_action: 'roll', player_to_accuse: 'seat_2')).to be_failure
        end

        it 'will fail if you choose to roll, and nationality is set' do
          expect(validate.(player_action: 'roll', nationality: 'french')).to be_failure
        end

        it 'will fail if you choose to roll, and card_to_use is set' do
          expect(validate.(player_action: 'roll', card_to_use: 1)).to be_failure
        end

        it 'will successfully validate if you choose to roll and try to set the result as an admin' do
          expect(validate.(player_action: 'roll', choose_result: 5)).to be_success
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

        it 'will fail if you attempt to choose a result while making an accusation' do
          expect(
            validate.(
              player_action:    'make_accusation',
              player_to_accuse: 'seat_2',
              nationality:      'french',
              choose_result:    5
            )
          ).to be_failure
        end
      end
    end
  end
end