# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::EliminatePlayerResult do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:target_player_model, &->{PlayerMock::new(seat: 5)})
  let(:transfer_money, &->{CallableStub::new})
  let(:transfer_equipment, &->{CallableStub::new})
  let(:transfer_wild_cards, &->{CallableStub::new})
  let(:return_player, &->{1})
  let(:eliminate_player) do
    ->(target_player_model) do
      SpyAlleyApplication::Results::EliminatePlayerResult::new(
        transfer_money: transfer_money,
        transfer_equipment: transfer_equipment,
        transfer_wild_cards: transfer_wild_cards
      ).call(
        player_model: player_model,
        target_player_model: target_player_model,
        change_orders: change_orders,
        return_player: 'seat_2'
      )
    end
  end
  describe '#call' do
    it 'calls change_orders#eliminate_player_action' do
      expect{eliminate_player.(target_player_model)}.to(
        change{change_orders.times_called[:eliminate_player_action]}.by(1)
      )
    end
    it 'calls transfer_money' do
      eliminate_player.(target_player_model)
      expect(transfer_money.called_with).to eql({
        to: player_model,
        from: target_player_model,
        change_orders: change_orders
      })
    end
    it 'calls transfer_equipment' do
      eliminate_player.(target_player_model)
      expect(transfer_equipment.called_with).to eql({
        to: player_model,
        from: target_player_model,
        change_orders: change_orders
      })
    end
    it 'calls transfer_wild_cards' do
      eliminate_player.(target_player_model)
      expect(transfer_wild_cards.called_with).to eql({
        to: player_model,
        from: target_player_model,
        change_orders: change_orders
      })
    end
    it 'calls change_orders#add_choose_new_spy_identity_option' do
      expect{eliminate_player.(target_player_model)}.to(
        change{change_orders.times_called[:add_choose_new_spy_identity_option]}.by(1)
      )
    end
  end
end

