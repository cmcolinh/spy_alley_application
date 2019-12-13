# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::SoldTopSecretInformation::Ten do
  let(:player_model, &->{PlayerMock::new})
  let(:opponent_models, &->{[PlayerMock::new(seat: 6)]})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:sold_top_secret_information, &->{CallableStub::new})
  let(:sold_for_ten) do
    SpyAlleyApplication::Results::SoldTopSecretInformation::Ten::new(
      sold_top_secret_information: sold_top_secret_information
    )
  end
  describe '#call' do
    it 'calls sold_top_secret_information with 10 money earned' do
      sold_for_ten.(
        player_model: player_model,
        opponent_models: opponent_models,
        action_hash: action_hash,
        change_orders: change_orders
      )
      expect(sold_top_secret_information.called_with[:money_earned]).to eql(10)
    end
  end
end
