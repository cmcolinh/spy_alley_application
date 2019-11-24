# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::EliminatePlayerResult::TransferWildCards do
  let(:player_model, &->{PlayerMock::new(wild_cards: 0)})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:transfer_wild_cards) do
    ->(target_player_model) do
      SpyAlleyApplication::Results::EliminatePlayerResult::TransferWildCards::new.(
        from: target_player_model,
        to: player_model,
        change_orders: change_orders
      )
    end
  end
  describe '#call' do
    describe 'when opponent has no wild_cards' do
      let(:target_player_model, &->{PlayerMock::new(wild_cards: 0)})
      it 'does not call change_orders#subtract_wild_card_action' do
        expect{transfer_wild_cards.(target_player_model)}.not_to(
          change{change_orders.times_called[:subtract_wild_card_action]}
        )
      end
      it 'does not call change_orders#add_wild_card_action' do
        expect{transfer_wild_cards.(target_player_model)}.not_to(
          change{change_orders.times_called[:add_wild_card_action]}
        )
      end
    end
    describe 'when opponent has one wild_card' do
      let(:target_player_model, &->{PlayerMock::new(wild_cards: 1)})
      it 'calls change_orders#subtract_wild_card_action once' do
        expect{transfer_wild_cards.(target_player_model)}.to(
          change{change_orders.times_called[:subtract_wild_card_action]}.by(1)
        )
      end
      it 'calls change_orders#add_wild_card_action once' do
        expect{transfer_wild_cards.(target_player_model)}.to(
          change{change_orders.times_called[:add_wild_card_action]}.by(1)
        )
      end
    end
    describe 'when opponent has two wild_cards' do
      let(:target_player_model, &->{PlayerMock::new(wild_cards: 2)})
      it 'calls change_orders#subtract_wild_card_action twice' do
        expect{transfer_wild_cards.(target_player_model)}.to(
          change{change_orders.times_called[:subtract_wild_card_action]}.by(2)
        )
      end
      it 'calls change_orders#add_wild_card_action twice' do
        expect{transfer_wild_cards.(target_player_model)}.to(
          change{change_orders.times_called[:add_wild_card_action]}.by(2)
        )
      end
    end
  end
end

