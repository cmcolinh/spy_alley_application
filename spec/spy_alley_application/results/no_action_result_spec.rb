# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::NoActionResult do
  let(:player_model, &->{PlayerMock::new})
  let(:opponent_models, &->{[PlayerMock::new]})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:next_player_up, &->{CallableStub::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:no_result) do
    SpyAlleyApplication::Results::NoActionResult::new(next_player_up_for: next_player_up)
  end
  describe '#call' do
    it "marks turn_complete? as true, indicating that it will not remain the same player's turn" do
      no_result.(
        player_model: player_model,
        opponent_models: opponent_models,
        change_orders: change_orders,
        action_hash: action_hash
      )
      expect(next_player_up.called_with[:turn_complete?]).to be true
    end
  end
end
