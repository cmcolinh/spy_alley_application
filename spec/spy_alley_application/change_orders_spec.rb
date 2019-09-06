# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::ChangeOrders do
  let (:change_orders){SpyAlleyApplication::ChangeOrders::new}
  describe '#get_action_hash' do
    before(:each) do
      change_orders.add_action(action_hash: {player_action: 'roll'})
    end
    let(:calling_method) do
      -> do
        change_orders.get_action_hash
      end
    end
    it 'returns a hash representation of the ActionHashElement node' do
      expect(calling_method.()).to eql({player_action: 'roll'})
    end

    it 'removes the action_hash node from @changes' do
      expect{calling_method.()}.to change{change_orders.changes.length}.by(-1)
    end
  end

  describe '#add_die_roll' do
    let(:calling_method) do
      -> do
        change_orders.add_die_roll(
          player: {game: 1, seat: 1},
          rolled: 1
        )
      end
    end
    it 'adds two total nodes' do
      expect{calling_method.()}.to change{change_orders.changes.length}.by(2)
    end
  end
end
