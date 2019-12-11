# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::SoldTopSecretInformation do
  let(:player_model, &->{PlayerMock::new})
  let(:opponent_models, &->{[PlayerMock::new(seat: 5)]})
  let(:next_player_up, &->{CallableStub::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:sold_top_secret_information) do
    SpyAlleyApplication::Results::SoldTopSecretInformation::new(next_player_up_for: next_player_up)
  end
  describe '#call' do
    it "marks turn_complete? as true, indicating that it will not remain the same player's turn" do
      sold_top_secret_information.(
        player_model: player_model,
        opponent_models: opponent_models,
        change_orders: change_orders,
        money_earned: 10
      )
      expect(next_player_up.called_with[:turn_complete?]).to be true
    end

    it 'calls change_orders#add_money_action once' do
      sold_top_secret_information.(
        player_model: player_model,
        opponent_models: opponent_models,
        change_orders: change_orders,
        money_earned: 10
      )
      expect(change_orders.times_called[:add_money_action]).to eql 1
    end
  end
end
