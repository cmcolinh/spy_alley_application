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
    let(:calling_method) {
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

  describe '#confiscate_materials' do
    define_method(:confiscation_price, &->{{'russian codebook' => 5, 'wild card' => 50}})
    let(:calling_method) do
      -> do 
        confiscate_materials(
          player_model: player,
          change_orders: change_orders,
          target_player_model: target_player,
          equipment_to_confiscate: 'russian codebook'
        )
      end
    end
    it 'returns the equipment confiscated' do
      expect(calling_method.()).to eq('russian codebook')
    end

    it 'calls change_orders#add_equipment_action once' do
      calling_method.()
      expect(change_orders.times_called[:add_equipment_action]).to eql(1)
    end

    it 'calls change_orders#subtract_money_action once' do
      calling_method.()
      expect(change_orders.times_called[:subtract_money_action]).to eql(1)
    end

    it 'calls change_orders#subtract_equipment_action once' do
      calling_method.()
      expect(change_orders.times_called[:subtract_equipment_action]).to eql(1)
    end

    it 'calls change_orders#add_money_action once' do
      calling_method.()
      expect(change_orders.times_called[:add_money_action]).to eql(1)
    end

    it 'calls change_orders#add_action once' do
      calling_method.()
      expect(change_orders.times_called[:add_action]).to eql(1)
    end


    it 'targets the correct player with change_orders#add_equipment_action' do
      calling_method.()
      expect(change_orders.target[:add_equipment_action]).to eql(player.seat)
    end

    it 'targets the correct player with change_orders#subtract_money_action' do
      calling_method.()
      expect(change_orders.target[:subtract_money_action]).to eql(player.seat)
    end

    it 'targets the correct player with change_orders#subtract_equipment_action' do
      calling_method.()
      expect(change_orders.target[:subtract_equipment_action]).to eql(target_player.seat)
    end

    it 'targets the correct player with change_orders#add_money_action' do
      calling_method.()
      expect(change_orders.target[:add_money_action]).to eql(target_player.seat)
    end
  end
end
