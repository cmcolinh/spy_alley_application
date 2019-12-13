# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::TakeAnotherTurn do
  let(:player_model, &->{PlayerMock::new})
  let(:opponent_models, &->{[PlayerMock::new]})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:next_player_up, &->{CallableStub::new})
  let(:take_another_turn) do
    SpyAlleyApplication::Results::TakeAnotherTurn::new(next_player_up_for: next_player_up)
  end
  describe '#call' do
    it "marks turn_complete? as false, indicating that it will remain the same player's turn" do
      take_another_turn.(
        player_model: player_model,
        opponent_models: opponent_models,
        change_orders: change_orders,
        action_hash: action_hash
      )
      expect(next_player_up.called_with[:turn_complete?]).to be false
    end
  end
end
