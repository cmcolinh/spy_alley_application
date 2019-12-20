# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::NextPlayerUp::NextPlayerOptions do
  let(:opponent_models, &->{[PlayerMock::new(seat: 1), PlayerMock::new(seat: 3)]})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do
    {
      player_action: 'roll',
    }
  end
  let(:next_player_options) do
    SpyAlleyApplication::Results::NextPlayerUp::NextPlayerOptions::new
  end
  describe '#call' do
    describe 'player has no move cards' do
      let(:next_player_model, &->{PlayerMock::new(seat: 2, move_cards: [])})
      it 'accepts roll' do
        next_player_options.(
          next_player_model: next_player_model,
          opponent_models: opponent_models,
          action_hash: action_hash,
          change_orders: change_orders
        )
        expect(change_orders.target[:accept_roll]).to eql(true)
      end

      it 'accepts make_accusation, naming the opponents listed' do
        next_player_options.(
          next_player_model: next_player_model,
          opponent_models: opponent_models,
          action_hash: action_hash,
          change_orders: change_orders
        )
        expect(change_orders.target.dig(:accept_make_accusation, :player))
          .to contain_exactly('seat_1', 'seat_3')
      end

      it 'does not accept use_move_card' do
        next_player_options.(
          next_player_model: next_player_model,
          opponent_models: opponent_models,
          action_hash: action_hash,
          change_orders: change_orders
        )
        expect(change_orders.target[:accept_use_move_card]).to be nil
      end
    end

    describe 'player has move cards' do
      let(:player_model, &->{PlayerMock::new(seat: 2, move_cards: {1 => 1, 2 => 2})})
      it 'accepts roll' do
        next_player_options.(
          next_player_model: player_model,
          opponent_models: opponent_models,
          action_hash: action_hash,
          change_orders: change_orders
        )
        expect(change_orders.target[:accept_roll]).to eql(true)
      end

      it 'accepts make_accusation, naming the opponents listed' do
        next_player_options.(
          next_player_model: player_model,
          opponent_models: opponent_models,
          action_hash: action_hash,
          change_orders: change_orders
        )
        expect(change_orders.target.dig(:accept_make_accusation, :player))
          .to contain_exactly('seat_1', 'seat_3')
      end

      it 'does not accept use_move_card' do
        next_player_options.(
          next_player_model: player_model,
          opponent_models: opponent_models,
          action_hash: action_hash,
          change_orders: change_orders
        )
        expect(change_orders.target[:accept_use_move_card]).to contain_exactly 1, 2
      end
    end
  end
end