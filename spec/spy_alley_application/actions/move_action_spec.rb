# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Actions::MoveIdentityAction do
  let(:player_model, &->{PlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do |identity|
    ->(identity) do
      {
        player_action: 'move',
        space:         '1'
      }
    end
  end
  let (:move) do
    ->(*args) do
      finished_lap = args[:finished_lap?] || false
      SpyAlleyApplication
  
  describe '#move' do
    let(:space_to_move, &->{'1'})
    let(:calling_method) {
      ->{move.().(player_model: player, change_orders: change_orders, space_to_move: space_to_move)}
    }
    let(:finished_lap){->(*args){true}}

    it 'returns the space to move' do
      expect(calling_method.()).to eql('1')
    end

    it 'calls change_orders.add_move_action' do
      move(player_model: player, change_orders: change_orders, space_to_move: space_to_move)
      expect(change_orders.times_called[:add_move_action]).to eql(1)
    end

    it 'does not call change_orders#add_money_action when the player does not complete a lap' do
      move(player_model: player, change_orders: change_orders, space_to_move: space_to_move)
      expect(change_orders.times_called[:add_money_action]).to eql(0)
    end

    it 'calls change_orders#add_money_action when the player completes a lap' do
      move.(finished_lap?: true).(player_model: player, change_orders: change_orders, space_to_move: space_to_move)
      expect(change_orders.times_called[:add_money_action]).to eql(1)
    end
  end
end
