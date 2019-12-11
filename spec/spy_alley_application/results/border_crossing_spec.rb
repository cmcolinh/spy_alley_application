# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::BorderCrossing do
  let(:player_model, &->{PlayerMock::new})
  let(:opponent_models, &->{[PlayerMock::new]})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:next_player_up, &->{CallableStub::new})
  let(:border_crossing) do
    SpyAlleyApplication::Results::BorderCrossing::new(next_player_up_for: next_player_up)
  end
  describe '#call' do
    it "marks turn_complete? as true, indicating that it will not remain the same player's turn" do
      border_crossing.(
        player_model: player_model,
        opponent_models: opponent_models,
        change_orders: change_orders,
      )
      expect(next_player_up.called_with[:turn_complete?]).to be true
    end

    it 'calls change_orders#subtract_money_action once' do
      expect do
        border_crossing.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
        )
      end.to change{change_orders.times_called[:subtract_money_action]}.by(1)
    end
  end
end
