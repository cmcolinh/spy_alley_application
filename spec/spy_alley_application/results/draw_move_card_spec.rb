# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::DrawMoveCard do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do
    {
      player_action: 'roll'
    }
  end
  let(:draw_move_card, &->{SpyAlleyApplication::Results::DrawMoveCard::new})
  describe '#call' do
    describe 'move card deck is empty' do
      it "returns false, indicating that it will not remain the same player's turn" do
        expect(
          draw_move_card.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            decks_model: DecksModelMock::new(top_move_card: nil)
          )
        ).to be false
      end
    end
  end
end
