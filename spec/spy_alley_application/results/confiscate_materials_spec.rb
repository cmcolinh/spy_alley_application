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
      equipment: ['spanish password', 'spanish disguise', 'spanish codebook', 'spanish key', 'wild card']
    )
  end
  let(:target_player_model, &->{[opponent1, opponent2, opponent3]})
  describe '#call' do
    describe 'with less than 5 money' do
      let(:player_model) do
        PlayerMock::new(
          location: '2s',
          money: 4,
          equipment: ['french password', 'german disguise', 'spanish codebook']
        )
      end
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
  end
end
