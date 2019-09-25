# frozen_string_literal: true

include SpyAlleyApplication::Actions

RSpec.describe SpyAlleyApplication::Actions do
  let(:player, &->{PlayerMock::new})
  let(:target_player, &->{TargetPlayerMock::new})
  let(:change_orders, &->{ChangeOrdersMock::new})

  describe '#roll' do
    let(:roll_die, &->{->{1}})
    let(:calling_method) {
      ->{roll(player_model: player, change_orders: change_orders, roll_die: roll_die)}
    }

    it 'returns the number rolled' do
      expect(calling_method.()).to eql(1)
    end

    it 'calls change_orders' do
      roll(player_model: player, change_orders: change_orders, roll_die: roll_die)
      expect(change_orders.times_called[:add_die_roll]).to eql(1)
    end
  end

  describe '#use_move_card' do
    let(:card_to_use, &->{1})
    let(:calling_method) {
      ->{use_move_card(player_model: player, change_orders: change_orders, card_to_use: card_to_use)}
    }
    it 'returns the card used' do
      expect(calling_method.()).to eql(1)
    end

    it 'calls change_orders' do
      use_move_card(player_model: player, change_orders: change_orders, card_to_use: card_to_use)
      expect(change_orders.times_called[:add_use_move_card]).to eql(1)
    end
  end

  describe '#move' do
    let(:space_to_move, &->{'1'})
    let(:calling_method) {'seat_2', 'russian password'
      ->{move(player_model: player, change_orders: change_orders, space_to_move: space_to_move)}
    }
    define_method(:finished_lap, &->(*args){false})

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
      def finished_lap(*args)
        true
      end
      move(player_model: player, change_orders: change_orders, space_to_move: space_to_move)
      expect(change_orders.times_called[:add_money_action]).to eql(1)
    end
  end
end
