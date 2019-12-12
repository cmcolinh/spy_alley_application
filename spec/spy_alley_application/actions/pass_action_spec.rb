# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Actions::PassAction do
  let(:player_model, &->{PlayerMock::new})
  let(:opponent_models, &->{[PlayerMock::new(seat: 2)]})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:next_player_up, &->{CallableStub::new})
  let(:action_hash, &->{{player_action: 'pass'}})
  let(:pass) do
    SpyAlleyApplication::Actions::PassAction::new(next_player_up_for: next_player_up)
  end
  describe '#call' do
    it "marks turn_complete? as true, indicating that it will not remain the same player's turn" do
      pass.(
        player_model: player_model,
        opponent_models: opponent_models,
        change_orders: change_orders,
        action_hash: action_hash
      )
      expect(next_player_up.called_with[:turn_complete?]).to be true
    end

    it 'calls change_orders#add_pass_action' do
      pass.(
        player_model: player_model,
        opponent_models: opponent_models,
        change_orders: change_orders,
        action_hash: action_hash)
      expect(change_orders.times_called[:add_pass_action]).to eq(1)
    end
  end
end
