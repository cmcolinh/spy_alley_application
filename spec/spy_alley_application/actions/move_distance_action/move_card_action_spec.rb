# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Actions::MoveDistanceAction::RollAction do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do
    ->(card_to_use) do
      {player_action: 'use_move_card', card_to_use: card_to_use}
    end
  end
  let(:use_move_card, &->{SpyAlleyApplication::Actions::MoveDistanceAction::MoveCardAction::new})
  describe '#call' do
    let(:card_to_use, &->{1})
    let(:calling_method) do
      ->(card_to_use) do
        use_move_card.(
          player_model:  player_model,
          change_orders: change_orders,
          action_hash:   action_hash.(card_to_use)
        )
      end
    end
    it 'returns the card used' do
      expect(calling_method.(card_to_use)).to eql(1)
    end

    it 'calls change_orders' do
      use_move_card.(
        player_model:  player_model,
        change_orders: change_orders,
        action_hash:   action_hash.(card_to_use)
      )
      expect(change_orders.times_called[:add_use_move_card]).to eql(1)
    end
  end
end
