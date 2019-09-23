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

  describe '#make_accusation' do
    let(:eliminating_player, &->{{}})
    let(:eliminated_player,  &->{{}})
    define_method(:eliminate_player) do |options={}|
      eliminating_player[:seat] = options[:player_model].seat
      eliminated_player[:seat]  = options[:target_player_model].seat
    end
    let(:making_guess) do
      ->(correct:, free_guess:) do
        make_accusation(
          player_model: player,
          change_orders: change_orders,
          target_player_model: target_player,
          guess: correct ? 'german' : 'spanish',
          free_guess?: free_guess
        )
      end
    end
    describe 'free guess' do
      describe 'when guess is correct' do
        it 'returns true to indicate a correct guess' do
          expect(making_guess.(correct: true, free_guess: true)).to eql(true)
        end

        it 'targets the target player for elimination' do
          making_guess.(correct: true, free_guess: true)
          expect(eliminated_player[:seat]).to eql 2
        end

        it 'targets the guessing player as an eliminator' do
          making_guess.(correct: true, free_guess: true)
          expect(eliminating_player[:seat]).to eql 1
        end

        it 'calls change_orders#add_action twice' do
          making_guess.(correct: true, free_guess: true)
          expect(change_orders.times_called[:add_action]).to eql 2
        end
      end
      describe 'when guess is incorrect' do
        it 'returns false to indicate an incorrect guess' do
          expect(making_guess.(correct: false, free_guess: true)).to eql(false)
        end

        it 'does not target a player for elimination' do
          making_guess.(correct: false, free_guess: true)
          expect(eliminated_player[:seat]).to be nil
        end

        it 'does not target any player as an eliminator' do
          making_guess.(correct: false, free_guess: true)
          expect(eliminating_player[:seat]).to be nil
        end

        it 'calls change_orders#add_action twice' do
          making_guess.(correct: false, free_guess: true)
          expect(change_orders.times_called[:add_action]).to eql 2
        end
      end
    end
    describe 'non free guess' do
      describe 'when guess is correct' do
        it 'returns true to indicate a correct guess' do
          expect(making_guess.(correct: true, free_guess: false)).to eql(true)
        end

        it 'targets the target player for elimination' do
          making_guess.(correct: true, free_guess: false)
          expect(eliminated_player[:seat]).to eql 2
        end

        it 'targets the guessing player as an eliminator' do
          making_guess.(correct: true, free_guess: false)
          expect(eliminating_player[:seat]).to eql 1
        end

        it 'calls change_orders#add_action twice' do
          making_guess.(correct: true, free_guess: false)
          expect(change_orders.times_called[:add_action]).to eql 2
        end
      end
      describe 'when guess is incorrect' do
        it 'returns false to indicate an incorrect guess' do
          expect(making_guess.(correct: false, free_guess: false)).to eql(false)
        end

        it 'targets the guessing player for elimination' do
          making_guess.(correct: false, free_guess: false)
          expect(eliminated_player[:seat]).to eql 1
        end

        it 'targets the target player as an eliminator' do
          making_guess.(correct: false, free_guess: false)
          expect(eliminating_player[:seat]).to eql 2
        end

        it 'calls change_orders#add_action twice' do
          making_guess.(correct: false, free_guess: false)
          expect(change_orders.times_called[:add_action]).to eql 2
        end
      end
    end
  end

  describe '#choose_new_spy_identity' do
    let(:calling_method) do
      -> do
        choose_spy_identity(
          player_model: player,
          change_orders: change_orders,
          identity_chosen: 'russian'
        )
      end
    end
    it 'returns the identity chosen' do
      expect(calling_method.()).to eql 'russian'
    end
    it 'calls change_orders#choose_new_spy_identity_action once' do
      calling_method.()
      expect(change_orders.times_called[:choose_new_spy_identity_action]).to eql 1
    end
  end
end

