# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Actions::FreeAccusationAction do
  let(:player_model,    &->{PlayerMock::new})
  let(:opponent_models, &->{[PlayerMock::new(seat: 2), PlayerMock::new(seat: 3)]})
  let(:change_orders,   &->{ChangeOrdersMock::new})
  let(:eliminate_player) do 
    ->(options={}) do
      eliminating_player[:seat] = options[:player_model].seat
      eliminated_player[:seat]  = options[:target_player_model].seat
    end
  end
  describe '#call' do
    let(:eliminating_player, &->{{}})
    let(:eliminated_player,  &->{{}})
    let(:make_accusation) do
      SpyAlleyApplication::Actions::FreeAccusationAction::new(eliminate_player: eliminate_player)
    end
    let(:making_guess) do
      ->(correct:, more_options: false) do
        make_accusation.(
          player_model:    player_model,
          change_orders:   change_orders,
          opponent_models: opponent_models,
          action_hash: {
            player_action:    'make_accusation',
            player_to_accuse: 'seat_2',
            nationality:      correct ? 'german' : 'spanish',
            free_accusation:  true,
          }.tap{|h| h[:accusation_targets] = ['seat_3'] if more_options}
        )
      end
    end
    describe 'when guess is correct' do
      describe 'there are more available guesses' do
        it 'targets the target player for elimination' do
          making_guess.(correct: true, more_options: true)
          expect(eliminated_player[:seat]).to eql 2
        end

        it 'targets the guessing player as an eliminator' do
          making_guess.(correct: true, more_options: true)
          expect(eliminating_player[:seat]).to eql 1
        end

        it 'calls change_orders#add_action twice' do
          making_guess.(correct: true, more_options: true)
          expect(change_orders.times_called[:add_action]).to eql 2
        end
      end
      describe 'there are no more available guesses' do
      end
    end
    describe 'when guess is incorrect' do
      describe 'there are more available guesses' do
        it 'does not target a player for elimination' do
          making_guess.(correct: false, more_options: true)
          expect(eliminated_player[:seat]).to be nil
        end

        it 'does not target any player as an eliminator' do
          making_guess.(correct: false, more_options: true)
          expect(eliminating_player[:seat]).to be nil
        end

        it 'calls change_orders#add_action twice' do
          making_guess.(correct: false, more_options: true)
          expect(change_orders.times_called[:add_action]).to eql 2
        end
      end
      describe 'there are no more available guesses' do
      end
    end
  end
end
