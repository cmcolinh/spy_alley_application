# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Actions::MoveDistanceAction::AdminRollAction do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll', choose_result: 1}})
  let(:roll, &->{SpyAlleyApplication::Actions::MoveDistanceAction::AdminRollAction::new})
  describe '#call' do
    it 'returns an array with the rolled number to be returned as the last element' do
      expect(
        roll.(player_model: player_model, change_orders: change_orders, action_hash: action_hash).last
      ).to eql(1)
    end

    it 'returns an array with the rolled number to be returned as the last element' do
      expect(
        roll.(player_model: player_model, change_orders: change_orders, action_hash: action_hash).last
      ).to eql(1)
    end

    it 'calls change_orders' do
      roll.(player_model: player_model, change_orders: change_orders, action_hash: action_hash)
      expect(change_orders.times_called[:add_admin_die_roll]).to eql(1)
    end
  end
end
