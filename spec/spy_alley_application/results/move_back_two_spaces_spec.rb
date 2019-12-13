# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::MoveBackTwoSpaces do
  let(:player_model, &->{PlayerMock::new})
  let(:opponent_models, &->{[PlayerMock::new(seat: 4)]})
  let(:next_player_up, &->{CallableStub::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:move_back_two_spaces) do
    SpyAlleyApplication::Results::MoveBackTwoSpaces::new(next_player_up_for: next_player_up)
  end
  describe '#call' do
    it "marks turn_complete? as true, indicating that it will not remain the same player's turn" do
      move_back_two_spaces.(
        player_model: player_model,
        opponent_models: opponent_models,
        action_hash: action_hash,
        change_orders: change_orders
      )
      expect(next_player_up.called_with[:turn_complete?]).to be true
    end

    it 'calls change_orders#add_move_back_two_spaces_result once' do
      expect{
        move_back_two_spaces.(
          player_model: player_model,
          opponent_models: opponent_models,
          action_hash: action_hash,
          change_orders: change_orders
        )
      }.to(change{change_orders.times_called[:add_move_back_two_spaces_result]}.by(1))
    end
  end
end