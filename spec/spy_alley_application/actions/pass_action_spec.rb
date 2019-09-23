# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Actions::PassAction do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'pass'}})
  let(:pass, &->{SpyAlleyApplication::Actions::PassAction::new})
  describe '#call' do
    it "returns literal value 'pass'" do
      expect(
        pass.(player_model: player_model, change_orders: change_orders, action_hash: action_hash)
      ).to eql('pass')
    end

    it 'calls change_orders#add_pass_action' do
      pass.(player_model: player_model, change_orders: change_orders, action_hash: action_hash)
      expect(change_orders.times_called[:add_pass_action]).to eq(1)
    end
  end
end
