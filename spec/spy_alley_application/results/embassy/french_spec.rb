# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::Embassy::French do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:embassy, &->{CallableStub::new})
  let(:french_embassy) do
    SpyAlleyApplication::Results::Embassy::French::new(embassy: embassy)
  end
  describe '#call' do
    it "embassy with nationality: 'french'" do
      french_embassy.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(embassy.called_with[:nationality]).to eql('french')
    end
  end
end
