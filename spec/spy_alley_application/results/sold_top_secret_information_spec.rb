# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::SoldTopSecretInformation do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:sold_top_secret_information, &->{SpyAlleyApplication::Results::SoldTopSecretInformation::new})
  describe '#call' do
    it "returns false, indicating that it will not remain the same player's turn" do
      expect(
        sold_top_secret_information.(
          player_model: player_model,
          change_orders: change_orders,
          money_earned: 10
        )
      ).to be false
    end

    it 'calls change_orders#add_money_action once' do
      sold_top_secret_information.(
        player_model: player_model,
        change_orders: change_orders,
        money_earned: 10
      )
      expect(change_orders.times_called[:add_money_action]).to eql 1
    end
  end
end
