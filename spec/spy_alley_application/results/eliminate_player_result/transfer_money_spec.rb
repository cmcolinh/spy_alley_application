# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::EliminatePlayerResult::TransferMoney do
  let(:player_model, &->{PlayerMock::new(money: 25)})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:transfer_money) do
    ->(target_player_model) do
      SpyAlleyApplication::Results::EliminatePlayerResult::TransferMoney::new.(
        from: target_player_model,
        to: player_model,
        change_orders: change_orders
      )
    end
  end
  describe '#call' do
    describe 'when opponent has no money' do
      let(:target_player_model, &->{PlayerMock::new(money: 0)})
      it 'does not call change_orders#subtract_money_action' do
        expect{transfer_money.(target_player_model)}.not_to(
          change{change_orders.times_called[:subtract_money_action]}
        )
      end
      it 'does not call change_orders#add_money_action' do
        expect{transfer_money.(target_player_model)}.not_to(
          change{change_orders.times_called[:add_money_action]}
        )
      end
    end
    describe 'when opponent has money' do
      let(:target_player_model, &->{PlayerMock::new(money: 10)})
      it 'calls change_orders#subtract_money_action' do
        expect{transfer_money.(target_player_model)}.to(
          change{change_orders.times_called[:subtract_money_action]}.by(1)
        )
      end
      it 'calls change_orders#add_money_action' do
        expect{transfer_money.(target_player_model)}.to(
          change{change_orders.times_called[:add_money_action]}.by(1)
        )
      end
    end
  end
end

