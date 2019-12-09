# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::DrawMoveCard do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:next_player_up, &->{CallableStub::new})
  let(:action_hash) do
    {
      player_action: 'roll'
    }
  end
  let(:draw_move_card) do
    SpyAlleyApplication::Results::DrawMoveCard::new(next_player_up_for: next_player_up)
  end

  describe '#call' do
    describe 'when move card deck is empty' do
      it "marks turn_complete? as true, indicating that it will not remain the same player's turn" do
          draw_move_card.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            decks_model: DecksModelMock::new(top_move_card: nil)
          )
          expect(next_player_up.called_with[:turn_complete?]).to be true
      end
      it 'does not call change_orders#add_draw_top_move_card' do
        expect{
          draw_move_card.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            decks_model: DecksModelMock::new(top_move_card: nil)
          )
        }.not_to change{change_orders.times_called[:add_draw_top_move_card]}
      end
    end
    describe 'when move card deck is not empty' do
      (1..6).each do |top_move_card|
        it "marks turn_complete? as true, indicating that it will not remain the same player's turn when top card is #{top_move_card}" do
          draw_move_card.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            decks_model: DecksModelMock::new(top_move_card: top_move_card)
          )
          expect(next_player_up.called_with[:turn_complete?]).to be true
        end
        it "calls change_orders#add_draw_top_move_card when top move card is #{top_move_card}" do
          expect{
            draw_move_card.(
              player_model: player_model,
              change_orders: change_orders,
              action_hash: action_hash,
              decks_model: DecksModelMock::new(top_move_card: top_move_card)
            )
          }.to change{change_orders.times_called[:add_draw_top_move_card]}.by(1)
        end
        it "calls change_orders#add_draw_top_move_card sending the top move card value when it is a #{top_move_card}" do
          draw_move_card.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            decks_model: DecksModelMock::new(top_move_card: top_move_card)
          )
          expect(change_orders.top_move_card).to eql(top_move_card)
        end
      end
    end
  end
end
