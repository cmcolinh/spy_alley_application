# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::NoActionResult do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do
    {
      player_action: 'roll'
    }
  end
  let(:no_result, &->{SpyAlleyApplication::Results::NoActionResult::new})
  describe '#call' do
    it "returns false, indicating that it will not remain the same player's turn" do
      expect(
        no_result.(
          player_model: player_model,
          change_orders: change_orders,
          action_hash: action_hash
        )
      ).to be false
    end
  end
end

