# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Actions::BuyEquipmentAction do
  define_method(:purchase_price, &->{{'american codebook' => 5, 'russian codebook' => 5}})
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:buy_equipment, &->{SpyAlleyApplication::Actions::BuyEquipmentAction::new})

  describe '#call' do
    describe 'when buying one item' do
      let(:calling_method) do
        -> do
          buy_equipment.(
            player_model:  player_model,
            change_orders: change_orders,
            action_hash:   {
              player_action:    'buy_equipment',
              equipment_to_buy: ['russian codebook']
            }
          )
        end
      end

      it 'returns the equipment input' do
        expect(calling_method.()).to eql(['russian codebook'])
      end

      it 'calls change_orders#add_equipment_action once' do
        calling_method.()
        expect(change_orders.times_called[:add_equipment_action]).to eql(1)
      end

      it 'calls change_orders#subtract_money_action once' do
        calling_method.()
        expect(change_orders.times_called[:subtract_money_action]).to eql(1)
      end

      it 'debits the correct price for the item purchased' do
        calling_method.()
        expect(change_orders.money_subtracted).to eql(5)
      end

      it 'calls change_orders#add_action once' do
        calling_method.()
        expect(change_orders.times_called[:add_action]).to eql(1)
      end
    end
    describe 'when buying two items' do
      let(:calling_method) do
        -> do
          buy_equipment.(
            player_model:  player_model,
            change_orders: change_orders,
            action_hash:   {
              player_action:    'buy_equipment',
              equipment_to_buy: ['russian codebook', 'american codebook']
            }
          )
        end
      end

      it 'returns the equipment input' do
        expect(calling_method.()).to eql(['russian codebook', 'american codebook'])
      end

      it 'calls change_orders#add_equipment_action twice' do
        calling_method.()
        expect(change_orders.times_called[:add_equipment_action]).to eql(2)
      end

      it 'calls change_orders#subtract_money_action once' do
        calling_method.()
        expect(change_orders.times_called[:subtract_money_action]).to eql(1)
      end

      it 'debits the correct price for the items purchased' do
        calling_method.()
        expect(change_orders.money_subtracted).to eql(10)
      end

      it 'calls change_orders#add_action once' do
        calling_method.()
        expect(change_orders.times_called[:add_action]).to eql(1)
      end
    end
  end
end
