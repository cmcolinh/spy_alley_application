# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::MoveBackTwoSpaces do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:move_back_two_spaces, &->{SpyAlleyApplication::Results::MoveBackTwoSpaces::new})
  describe '#call' do
    it "returns false, indicating that it will not remain the same player's turn" do
      expect(move_back_two_spaces.(player_model: player_model, change_orders: change_orders)).to be false
    end

    it 'calls change_orders#add_move_back_two_spaces_result once' do
      expect{move_back_two_spaces.(player_model: player_model, change_orders: change_orders)}.to(
        change{change_orders.times_called[:add_move_back_two_spaces_result]}.by(1)
      )
    end
  end
end