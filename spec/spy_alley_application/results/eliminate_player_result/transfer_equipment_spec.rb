# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::EliminatePlayerResult::TransferEquipment do
  let(:player_model, &->{PlayerMock::new(equipment: ['russian password'])})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:transfer_equipment) do
    ->(target_player_model) do
      SpyAlleyApplication::Results::EliminatePlayerResult::TransferEquipment::new.(
        from: target_player_model,
        to: player_model,
        change_orders: change_orders
      )
    end
  end
  describe '#call' do
    describe 'when opponent has no equipment' do
      let(:target_player_model, &->{PlayerMock::new(equipment: [])})
      it 'does not call change_orders#subtract_equipment_action' do
        expect{transfer_equipment.(target_player_model)}.not_to(
          change{change_orders.times_called[:subtract_equipment_action]}
        )
      end
      it 'does not call change_orders#add_equipment_action' do
        expect{transfer_equipment.(target_player_model)}.not_to(
          change{change_orders.times_called[:add_equipment_action]}
        )
      end
    end
    describe 'when opponent only has equipment that the eliminating player already has' do
      let(:target_player_model, &->{PlayerMock::new(equipment: ['russian password'])})
      it 'calls change_orders#subtract_equipment_action once' do
        expect{transfer_equipment.(target_player_model)}.to(
          change{change_orders.times_called[:subtract_equipment_action]}.by(1)
        )
      end
      it 'does not call change_orders#add_equipment_action' do
        expect{transfer_equipment.(target_player_model)}.not_to(
          change{change_orders.times_called[:add_equipment_action]}
        )
      end
    end
    describe 'when opponent has one piece of equipment the eliminating player does not have' do
      let(:target_player_model, &->{PlayerMock::new(equipment: ['russian password', 'russian codebook'])})
      it 'calls change_orders#subtract_equipment_action twice' do
        expect{transfer_equipment.(target_player_model)}.to(
          change{change_orders.times_called[:subtract_equipment_action]}.by(2)
        )
      end
      it 'calls change_orders#add_equipment_action once' do
        expect{transfer_equipment.(target_player_model)}.to(
          change{change_orders.times_called[:add_equipment_action]}.by(1)
        )
      end
    end
    describe 'when opponent has two pieces of equipment the eliminating player does not have' do
      let(:target_player_model) do
        PlayerMock::new(
          equipment: ['russian password', 'russian codebook', 'russian key']
        )
      end
      it 'calls change_orders#subtract_equipment_action thrice' do
        expect{transfer_equipment.(target_player_model)}.to(
          change{change_orders.times_called[:subtract_equipment_action]}.by(3)
        )
      end
      it 'calls change_orders#add_equipment_action twice' do
        expect{transfer_equipment.(target_player_model)}.to(
          change{change_orders.times_called[:add_equipment_action]}.by(2)
        )
      end
    end
  end
end
