# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::MoveResult do
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:buy_equipment, &->{SpyAlleyApplication::Results::BuyEquipment::new})
  describe '#call' do
    it "returns true, indicating that it will remain the same player's turn" do
      buy_equipment.(change_orders: change_orders, purchase_options: ['french password'], purchase_limit: 1)
      expect(change_orders.times_called[:add_buy_equipment_option]).to eql 1
    end

    it 'calls change_orders#add_buy_equipment_option once' do
      buy_equipment.(change_orders: change_orders, purchase_options: ['french password'], purchase_limit: 1)
      expect(change_orders.times_called[:add_buy_equipment_option]).to eql 1
    end
  end
end
