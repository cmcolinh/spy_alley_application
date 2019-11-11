# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::SoldTopSecretInformation::Twenty do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:sold_top_secret_information, &->{CallableStub::new})
  let(:sold_for_twenty) do
    SpyAlleyApplication::Results::SoldTopSecretInformation::Twenty::new(
      sold_top_secret_information: sold_top_secret_information
    )
  end
  describe '#call' do
    it 'calls sold_top_secret_information with 20 money earned' do
      sold_for_twenty.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(sold_top_secret_information.called_with[:money_earned]).to eql(20)
    end
  end
end
