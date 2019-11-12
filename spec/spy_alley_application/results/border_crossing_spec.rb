# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::BorderCrossing do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:border_crossing, &->{SpyAlleyApplication::Results::BorderCrossing::new})
  describe '#call' do
    it "returns false, indicating that it will not remain the same player's turn" do
      expect(
        border_crossing.(
          player_model: player_model,
          change_orders: change_orders,
        )
      ).to be false
    end

    it 'calls change_orders#subtract_money_action once' do
      expect do
        border_crossing.(
          player_model: player_model,
          change_orders: change_orders,
        )
      end.to change{change_orders.times_called[:subtract_money_action]}.by(1)
    end
  end
end
