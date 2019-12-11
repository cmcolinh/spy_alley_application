# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::DrawFreeGift do
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:opponent_models, &->{[PlayerMock::new]})
  let(:next_player_up, &->{CallableStub::new})
  let(:action_hash) do
    {
      player_action: 'roll'
    }
  end
  let(:draw_free_gift) do
    SpyAlleyApplication::Results::DrawFreeGift::new(next_player_up_for: next_player_up)
  end
  describe '#call' do
    describe 'when top card is wild card' do
      let(:player_model, &->{PlayerMock::new})
      it 'calls change_orders#add_draw_top_free_gift_card' do
        expect{
          draw_free_gift.(
            player_model: player_model,
            opponent_models: opponent_models,
            change_orders: change_orders,
            action_hash: action_hash,
            decks_model: DecksModelMock::new(top_free_gift_card: 'wild card')
          )
        }.to change{change_orders.times_called[:add_draw_top_free_gift_card]}.by(1)
      end
      it "marks turn_complete? as true, indicating that it will not remain the same player's turn" do
        draw_free_gift.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          decks_model: DecksModelMock::new(top_free_gift_card: 'wild card')
        )
        expect(next_player_up.called_with[:turn_complete?]).to be true
      end
      it 'does not call change_orders#add_equipment_action' do
        expect{
          draw_free_gift.(
            player_model: player_model,
            opponent_models: opponent_models,
            change_orders: change_orders,
            action_hash: action_hash,
            decks_model: DecksModelMock::new(top_free_gift_card: 'wild card')
          )
        }.not_to change{change_orders.times_called[:add_equipment_action]}
      end
    end
    describe 'when top card is not wild card, but user already has the equipment' do
      let(:player_model, &->{PlayerMock::new(equipment: ['russian password'])})
      it 'calls change_orders#add_draw_top_free_gift_card' do
        expect{
          draw_free_gift.(
            player_model: player_model,
            opponent_models: opponent_models,
            change_orders: change_orders,
            action_hash: action_hash,
            decks_model: DecksModelMock::new(top_free_gift_card: 'russian password')
          )
        }.to change{change_orders.times_called[:add_draw_top_free_gift_card]}.by(1)
      end
      it "marks turn_complete? as true, indicating that it will not remain the same player's turn" do
        draw_free_gift.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          decks_model: DecksModelMock::new(top_free_gift_card: 'russian password')
        )
        expect(next_player_up.called_with[:turn_complete?]).to be true
      end
      it 'does not call change_orders#add_equipment_action' do
        expect{
          draw_free_gift.(
            player_model: player_model,
            opponent_models: opponent_models,
            change_orders: change_orders,
            action_hash: action_hash,
            decks_model: DecksModelMock::new(top_free_gift_card: 'russian password')
          )
        }.not_to change{change_orders.times_called[:add_equipment_action]}
      end
    end
    describe 'when top card is not wild card, and user does not yet have the equipment' do
      let(:player_model, &->{PlayerMock::new(equipment: [])})
      it 'calls change_orders#add_draw_top_free_gift_card' do
        expect{
          draw_free_gift.(
            player_model: player_model,
            opponent_models: opponent_models,
            change_orders: change_orders,
            action_hash: action_hash,
            decks_model: DecksModelMock::new(top_free_gift_card: 'russian password')
          )
        }.to change{change_orders.times_called[:add_draw_top_free_gift_card]}.by(1)
      end
      it "marks turn_complete? as true, indicating that it will not remain the same player's turn" do
        draw_free_gift.(
          player_model: player_model,
          opponent_models: opponent_models,
          change_orders: change_orders,
          action_hash: action_hash,
          decks_model: DecksModelMock::new(top_free_gift_card: 'russian password')
        )
        expect(next_player_up.called_with[:turn_complete?]).to be true
      end
      it 'does calls change_orders#add_equipment_action' do
        expect{
          draw_free_gift.(
            player_model: player_model,
            opponent_models: opponent_models,
            change_orders: change_orders,
            action_hash: action_hash,
            decks_model: DecksModelMock::new(top_free_gift_card: 'russian password')
          )
        }.to change{change_orders.times_called[:add_equipment_action]}.by(1)
      end
    end
  end
end
