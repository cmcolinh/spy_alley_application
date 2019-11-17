# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::SpyEliminator do
  let(:player_model, &->{PlayerMock::new(location: '2s')})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do
    {
      player_action: 'roll'
    }
  end
  let(:spy_eliminator, &->{SpyAlleyApplication::Results::SpyEliminator::new})
  let(:opponent1, &->{PlayerMock.new(location: '0', seat: 2)})
  let(:opponent2, &->{PlayerMock.new(location: '1s', seat: 3)})
  let(:opponent3, &->{PlayerMock.new(location: '9s', seat: 4)})
  describe '#call' do
    describe 'no opponents in spy alley' do
      let(:target_player_model, &->{[opponent1]})
      it "returns false, indicating that it will not remain the same player's turn" do
        expect(
          spy_eliminator.(
            player_model: player_model,
            target_player_model: target_player_model,
            change_orders: change_orders,
            action_hash: action_hash
          )
        ).to be false
      end
      it 'does not call change_orders#add_spy_eliminator_option' do
        expect{
          spy_eliminator.(
            player_model: player_model,
            target_player_model: target_player_model,
            change_orders: change_orders,
            action_hash: action_hash
          )
        }.not_to change{change_orders.times_called[:add_spy_eliminator_option]}
      end
    end
    describe 'one opponent in spy alley' do
      let(:target_player_model, &->{[opponent1, opponent2]})
      it "returns true, indicating that it will remain the same player's turn" do
        expect(
          spy_eliminator.(
            player_model: player_model,
            target_player_model: target_player_model,
            change_orders: change_orders,
            action_hash: action_hash
          )
        ).to be true
      end
      it 'calls change_orders#add_spy_eliminator_option' do
        expect{
          spy_eliminator.(
            player_model: player_model,
            target_player_model: target_player_model,
            change_orders: change_orders,
            action_hash: action_hash
          )
        }.to change{change_orders.times_called[:add_spy_eliminator_option]}.by(1)
      end
      it 'calls change_orders#add_spy_eliminator_option with one target' do
        expect{
          spy_eliminator.(
            player_model: player_model,
            target_player_model: target_player_model,
            change_orders: change_orders,
            action_hash: action_hash
          )
        }.to change{(change_orders.target[:add_spy_eliminator_option] || []).length}.by(1)
      end
    end
    describe 'two opponents in spy alley' do
      let(:target_player_model, &->{[opponent1, opponent2, opponent3]})
      it "returns true, indicating that it will remain the same player's turn" do
        expect(
          spy_eliminator.(
            player_model: player_model,
            target_player_model: target_player_model,
            change_orders: change_orders,
            action_hash: action_hash
          )
        ).to be true
      end
      it 'calls change_orders#add_spy_eliminator_option' do
        expect{
          spy_eliminator.(
            player_model: player_model,
            target_player_model: target_player_model,
            change_orders: change_orders,
            action_hash: action_hash
          )
        }.to change{change_orders.times_called[:add_spy_eliminator_option]}.by(1)
      end
      it 'calls change_orders#add_spy_eliminator_option with two targets' do
        expect{
          spy_eliminator.(
            player_model: player_model,
            target_player_model: target_player_model,
            change_orders: change_orders,
            action_hash: action_hash
          )
        }.to change{(change_orders.target[:add_spy_eliminator_option] || []).length}.by(2)
      end
    end
  end
end
