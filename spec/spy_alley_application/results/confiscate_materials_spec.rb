# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::ConfiscateMaterials do
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do
    {
      player_action: 'roll'
    }
  end
  let(:confiscate_materials, &->{SpyAlleyApplication::Results::ConfiscateMaterials::new})
  let(:opponent1) do
    PlayerMock.new(
      location: '0',
      seat: 2,
      equipment: ['french password', 'french disguise', 'french codebook', 'french key']
    )
  end
  let(:opponent2) do
    PlayerMock.new(
      location: '1s',
      seat: 3,
      equipment: ['german password', 'german disguise', 'german codebook', 'german key']
    )
  end
  let(:opponent3) do
    PlayerMock.new(
      location: '9s',
      seat: 4,
      equipment: ['spanish password', 'spanish disguise', 'spanish codebook', 'spanish key'],
      wild_cards: 1
    )
  end
  let(:target_player_model, &->{[opponent1, opponent2, opponent3]})
  describe '#call' do
    describe 'with less than 5 money' do
      player_model = PlayerMock::new(
        location: '2s',
        money: 4,
        equipment: ['french password', 'german disguise', 'spanish codebook']
      )
      it "returns false, indicating the end of the player's turn" do
        expect(
          confiscate_materials.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            target_player_model: target_player_model
          )
        ).to be false
      end

      it 'does not call change_orders#add_confiscate_materials_option' do
        expect{
          confiscate_materials.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            target_player_model: target_player_model
          )
        }.not_to change{change_orders.times_called[:add_confiscate_materials_option]}
      end
    end
    describe 'with between 5 and 9 money' do
      player_model = PlayerMock::new(
        location: '2s',
        money: 9,
        equipment: ['french password', 'german disguise', 'spanish codebook']
      )
      it "returns true, indicating the player's turn will continue" do
        expect(
          confiscate_materials.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            target_player_model: target_player_model
          )
        ).to be true
      end
      it 'does call change_orders#add_confiscate_materials_option' do
        expect{
          confiscate_materials.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            target_player_model: target_player_model
          )
        }.to change{change_orders.times_called[:add_confiscate_materials_option]}.by(1)
      end
      it 'adds the correct equipment' do
        confiscate_materials.(
          player_model: player_model,
          change_orders: change_orders,
          action_hash: action_hash,
          target_player_model: target_player_model
        )
      expect(change_orders.target[:add_confiscate_materials_option]).to(
        eql({
          'seat_2' => ['french disguise'],
          'seat_3' => ['german password'],
          'seat_4' => ['spanish password', 'spanish disguise']
        }))
      end
    end
    describe 'with between 10 and 24 money' do
      player_model = PlayerMock::new(
        location: '2s',
        money: 24,
        equipment: ['french password', 'german disguise', 'spanish codebook']
      )
      it "returns true, indicating the player's turn will continue" do
        expect(
          confiscate_materials.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            target_player_model: target_player_model
          )
        ).to be true
      end
      it 'does call change_orders#add_confiscate_materials_option' do
        expect{
          confiscate_materials.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            target_player_model: target_player_model
          )
        }.to change{change_orders.times_called[:add_confiscate_materials_option]}.by(1)
      end
      it 'adds the correct equipment' do
        confiscate_materials.(
          player_model: player_model,
          change_orders: change_orders,
          action_hash: action_hash,
          target_player_model: target_player_model
        )
      expect(change_orders.target[:add_confiscate_materials_option]).to(
        eql({
          'seat_2' => ['french disguise', 'french codebook'],
          'seat_3' => ['german password', 'german codebook'],
          'seat_4' => ['spanish password', 'spanish disguise']
        }))
      end
    end
    describe 'with between 25 and 49 money' do
      player_model = PlayerMock::new(
        location: '2s',
        money: 49,
        equipment: ['french password', 'german disguise', 'spanish codebook']
      )
      it "returns true, indicating the player's turn will continue" do
        expect(
          confiscate_materials.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            target_player_model: target_player_model
          )
        ).to be true
      end
      it 'does call change_orders#add_confiscate_materials_option' do
        expect{
          confiscate_materials.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            target_player_model: target_player_model
          )
        }.to change{change_orders.times_called[:add_confiscate_materials_option]}.by(1)
      end
      it 'adds the correct equipment' do
        confiscate_materials.(
          player_model: player_model,
          change_orders: change_orders,
          action_hash: action_hash,
          target_player_model: target_player_model
        )
      expect(change_orders.target[:add_confiscate_materials_option]).to(
        eql({
          'seat_2' => ['french disguise', 'french codebook', 'french key'],
          'seat_3' => ['german password', 'german codebook', 'german key'],
          'seat_4' => ['spanish password', 'spanish disguise', 'spanish key']
        }))
      end
    end
    describe 'with 50 or more money' do
      player_model = PlayerMock::new(
        location: '2s',
        money: 200,
        equipment: ['french password', 'german disguise', 'spanish codebook'],
        wild_cards: 1
      )
      it "returns true, indicating the player's turn will continue" do
        expect(
          confiscate_materials.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            target_player_model: target_player_model
          )
        ).to be true
      end
      it 'does call change_orders#add_confiscate_materials_option' do
        expect{
          confiscate_materials.(
            player_model: player_model,
            change_orders: change_orders,
            action_hash: action_hash,
            target_player_model: target_player_model
          )
        }.to change{change_orders.times_called[:add_confiscate_materials_option]}.by(1)
      end
      it 'adds the correct equipment, allowing to steal a wild card while already having one' do
        confiscate_materials.(
          player_model: player_model,
          change_orders: change_orders,
          action_hash: action_hash,
          target_player_model: target_player_model
        )
      expect(change_orders.target[:add_confiscate_materials_option]).to(
        eql({
          'seat_2' => ['french disguise', 'french codebook', 'french key'],
          'seat_3' => ['german password', 'german codebook', 'german key'],
          'seat_4' => ['spanish password', 'spanish disguise', 'spanish key', 'wild card']
        }))
      end
    end
  end
end
