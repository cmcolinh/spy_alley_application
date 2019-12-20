# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::NextPlayerUp do
  let(:player_model, &->{PlayerMock::new(seat: 2)})
  let(:opponent_models, &->{[PlayerMock::new(seat: 1), PlayerMock::new(seat: 3)]})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do
    {
      player_action: 'roll',
    }
  end
  let(:next_player_options, &->{CallableStub::new})
  let(:next_player_up) do
    SpyAlleyApplication::Results::NextPlayerUp::new(next_player_options: next_player_options)
  end
  describe '#call' do
    describe 'when turn_complete? is false' do
      it 'calls change_orders#add_next_player_up once' do
        next_player_up.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          turn_complete?: false
        )
        expect(change_orders.times_called[:add_next_player_up]).to eql(1)
      end

      it 'calls change_orders#add_next_player_up, targeting the current player' do
        next_player_up.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          turn_complete?: false
        )
        expect(change_orders.target[:seat]).to eql(2)
      end

      it 'does not calls next_player_options' do
        next_player_up.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          turn_complete?: false
        )
        expect(next_player_options.called_with).to be_empty
      end
    end

    describe 'when turn_complete? is true' do
      it 'calls change_orders#add_next_player_up once' do
        next_player_up.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          turn_complete?: true
        )
        expect(change_orders.times_called[:add_next_player_up]).to eql(1)
      end

      it 'calls change_orders#add_next_player_up, targeting the player with the next available seat' do
        next_player_up.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          turn_complete?: true
        )
        expect(change_orders.target[:seat]).to eql(3)
      end

      it 'calls change_orders#add_next_player_up, targeting the player with the next available seat,' +
        ' wrapping around if necessary' do

        next_player_up.(
          player_model: PlayerMock::new(seat: 6),
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          turn_complete?: true
        )
        expect(change_orders.target[:seat]).to eql(1)
      end

      it 'calls next_player_options' do
        next_player_up.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          turn_complete?: true
        )
        expect(next_player_options.called_with).not_to be_empty
      end
    end
  end
end
