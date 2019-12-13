# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::BuyEquipment do
  let(:player_model, &->{PlayerMock::new})
  let(:opponent_models, &->{[PlayerMock::new(seat: 4)]})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:next_player_up, &->{CallableStub::new})
  let(:buy_equipment) do
    SpyAlleyApplication::Results::BuyEquipment::new(next_player_up_for: next_player_up)
  end
  describe '#call' do
    it "marks turn_complete? as false, indicating that it will remain the same player's turn" do
      buy_equipment.(
        player_model: player_model,
        opponent_models: opponent_models,
        change_orders: change_orders,
        action_hash: action_hash,
        purchase_options: ['french password'],
        purchase_limit: 1
      )
      expect(next_player_up.called_with[:turn_complete?]).to be false
    end

    it 'calls change_orders#add_buy_equipment_option once' do
      buy_equipment.(
        player_model: player_model,
        opponent_models: opponent_models,
        change_orders: change_orders,
        action_hash: action_hash,
        purchase_options: ['french password'],
        purchase_limit: 1
      )
      expect(change_orders.times_called[:add_buy_equipment_option]).to eql 1
    end
  end
end
