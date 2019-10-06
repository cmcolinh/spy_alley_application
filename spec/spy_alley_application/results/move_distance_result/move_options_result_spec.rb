# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::MoveDistanceResult::MoveOptionsResult do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:get_result, &->{SpyAlleyApplication::Results::MoveDistanceResult::MoveOptionsResult::new})
  describe '#call' do
    it 'returns thae move options input' do
      expect(
        get_result.(move_options:  ['15', '1s'], change_orders: change_orders)
      ).to match_array(%w(15 1s))
    end
    it 'calls change_orders#add_move_options' do
      expect{
        get_result.(change_orders: change_orders, move_options:  ['15', '1s'])
      }.to change{change_orders.times_called[:add_move_options]}.by 1
    end
  end
end

