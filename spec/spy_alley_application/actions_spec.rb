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

  describe '#pass' do
    it 'calls change_orders#add_pass_action' do
      pass(player_model: player, change_orders: change_orders)
      expect(change_orders.times_called[:add_pass_action]).to eq(1)
    end
  end

  describe '#buy_equipment' do
    define_method(:purchase_price, &->{{'american codebook' => 5, 'russian codebook' => 5}})
    describe 'when buying one item' do
      let(:calling_method) {
        buy_equipment(
          player_model: player,
          change_orders: change_orders,
          equipment_to_buy: ['russian codebook']
        )
      }

      it 'returns the equipment input' do
        expect(calling_method).to eql(['russian codebook'])
      end

      it 'calls change_orders#add_equipment_action once' do
        buy_equipment(
          player_model: player,
          change_orders: change_orders,
          equipment_to_buy: ['russian codebook']
        )
	expect(change_orders.times_called[:add_equipment_action]).to eql(1)
      end

      it 'calls change_orders#subtract_money_action once' do
        buy_equipment(
          player_model: player,
          change_orders: change_orders,
          equipment_to_buy: ['russian codebook']
        )
	expect(change_orders.times_called[:subtract_money_action]).to eql(1)
      end

      it 'debits the correct price for the item purchased' do
        buy_equipment(
          player_model: player,
          change_orders: change_orders,
          equipment_to_buy: ['russian codebook'] # cost is 5, per the purchase price chart above
        )
        expect(change_orders.money_subtracted).to eql(5)
      end

      it 'calls change_orders#add_action once' do
        buy_equipment(
          player_model: player,
          change_orders: change_orders,
          equipment_to_buy: ['russian codebook']
        )
	expect(change_orders.times_called[:add_action]).to eql(1)
      end
    end
    describe 'when buying two items' do
       let(:calling_method) {
         buy_equipment(
           player_model: player,
           change_orders: change_orders,
           equipment_to_buy: ['russian codebook', 'american codebook']
         )
        }

        it 'returns the equipment input' do
        expect(calling_method).to eql(['russian codebook', 'american codebook'])
      end

      it 'calls change_orders#add_equipment_action twice' do
        buy_equipment(
          player_model: player,
          change_orders: change_orders,
          equipment_to_buy: ['russian codebook', 'american codebook']
        )
	expect(change_orders.times_called[:add_equipment_action]).to eql(2)
      end

      it 'calls change_orders#subtract_money_action once' do
        buy_equipment(
          player_model: player,
          change_orders: change_orders,
          equipment_to_buy: ['russian codebook', 'american codebook']
        )
	expect(change_orders.times_called[:subtract_money_action]).to eql(1)
      end

      it 'debits the correct price for the items purchased' do
        buy_equipment(
          player_model: player,
          change_orders: change_orders,
          equipment_to_buy: ['russian codebook', 'american codebook'] # cost is 5 each, per the purchase price chart above
        )
        expect(change_orders.money_subtracted).to eql(10)
      end

      it 'calls change_orders#add_action once' do
        buy_equipment(
          player_model: player,
          change_orders: change_orders,
          equipment_to_buy: ['russian codebook', 'american codebook']
        )
	expect(change_orders.times_called[:add_action]).to eql(1)
      end
    end
  end
  describe '#confiscate_materials' do
    define_method(:confiscation_price, &->{{'russian codebook' => 5, 'wild card' => 50}})
    let(:calling_method) {
      confiscate_materials(
        player_model: player,
        change_orders: change_orders,
        target_player_model: target_player,
        equipment_to_confiscate: 'russian codebook'
      )
    }
    it 'returns the equipment confiscated' do
      expect(calling_method).to eq('russian codebook')
    end

    it 'calls change_orders#add_equipment_action once' do
      confiscate_materials(
        player_model: player,
        change_orders: change_orders,
        target_player_model: target_player,
        equipment_to_confiscate: 'russian codebook'
      )
      expect(change_orders.times_called[:add_equipment_action]).to eql(1)
    end

    it 'calls change_orders#subtract_money_action once' do
      confiscate_materials(
        player_model: player,
        change_orders: change_orders,
        target_player_model: target_player,
        equipment_to_confiscate: 'russian codebook'
      )
      expect(change_orders.times_called[:subtract_money_action]).to eql(1)
    end

    it 'calls change_orders#subtract_equipment_action once' do
      confiscate_materials(
        player_model: player,
        change_orders: change_orders,
        target_player_model: target_player,
        equipment_to_confiscate: 'russian codebook'
      )
      expect(change_orders.times_called[:subtract_equipment_action]).to eql(1)
    end

    it 'calls change_orders#add_money_action once' do
      confiscate_materials(
        player_model: player,
        change_orders: change_orders,
        target_player_model: target_player,
        equipment_to_confiscate: 'russian codebook'
      )
      expect(change_orders.times_called[:add_money_action]).to eql(1)
    end

    it 'calls change_orders#add_action once' do
      confiscate_materials(
        player_model: player,
        change_orders: change_orders,
        target_player_model: target_player,
        equipment_to_confiscate: 'russian codebook'
      )
      expect(change_orders.times_called[:add_action]).to eql(1)
    end


    it 'targets the correct player with change_orders#add_equipment_action' do
      confiscate_materials(
        player_model: player,
        change_orders: change_orders,
        target_player_model: target_player,
        equipment_to_confiscate: 'russian codebook'
      )
      expect(change_orders.target[:add_equipment_action]).to eql(player.seat)
    end

    it 'targets the correct player with change_orders#subtract_money_action' do
      confiscate_materials(
        player_model: player,
        change_orders: change_orders,
        target_player_model: target_player,
        equipment_to_confiscate: 'russian codebook'
      )
      expect(change_orders.target[:subtract_money_action]).to eql(player.seat)
    end

    it 'targets the correct player with change_orders#subtract_equipment_action' do
      confiscate_materials(
        player_model: player,
        change_orders: change_orders,
        target_player_model: target_player,
        equipment_to_confiscate: 'russian codebook'
      )
      expect(change_orders.target[:subtract_equipment_action]).to eql(target_player.seat)
    end

    it 'targets the correct player with change_orders#add_money_action' do
      confiscate_materials(
        player_model: player,
        change_orders: change_orders,
        target_player_model: target_player,
        equipment_to_confiscate: 'russian codebook'
      )
      expect(change_orders.target[:add_money_action]).to eql(target_player.seat)
    end
  end

  describe '#make_accusation' do
    describe 'free guess' do
      describe 'when guess is correct' do
        let(:calling_method) {
          make_accusation(
            player_model: player,
            change_orders: change_orders,
            target_player_model: target_player,
            guess: guess,
            free_guess?: true
          )
        }
        let(:guess, &->{'german'})
        it 'returns true for a successful guess' do
          expect(calling_method).to be true
        end

        it 'calls change_orders#add_money_action once' do
          make_accusation(
            player_model: player,
            change_orders: change_orders,
            target_player_model: target_player,
            guess: guess,
            free_guess?: true
          )
          expect(change_orders.times_called[:add_money_action]).to eql 1
        end

        it 'adds the exact amount of money that the target player had' do
          money = target_player.money
          make_accusation(
            player_model: player,
            change_orders: change_orders,
            target_player_model: target_player,
            guess: guess,
            free_guess?: true
          )
          expect(change_orders.money_added).to eql money
        end

        it 'calls change_orders#add_equipment_action twice, for the two pieces of equipment the' +
          ' eliminated player has that the eliminating player does not' do

          make_accusation(
            player_model: player,
            change_orders: change_orders,
            target_player_model: target_player,
            guess: guess,
            free_guess?: true
          )
          expect(change_orders.times_called[:add_equipment_action]).to eql 2
        end

        it 'calls change_orders#add_wild_card once for each wild card the eliminated player has' do
          make_accusation(
            player_model: player,
            change_orders: change_orders,
            target_player_model: target_player,
            guess: guess,
            free_guess?: true
          )
	  expect(change_orders.times_called[:add_wild_card_action]).to eql 2
	end
      end
    end
  end
end
