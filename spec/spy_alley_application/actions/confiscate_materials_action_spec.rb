# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Actions::ConfiscateMaterialsAction do
  let(:player_model, &->{PlayerMock::new})
  let(:opponent_models, &->{[TargetPlayerMock::new]})
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash) do
    ->(target_player, equipment) do
      {
        player_action:             'confiscate_materials',
        player_to_confiscate_from: target_player,
        equipment_to_confiscate:   equipment
      }
    end
  end
  let(:confiscate_materials, &->{SpyAlleyApplication::Actions::ConfiscateMaterialsAction::new})
  describe '#call' do
    describe '#confiscate_materials' do
      define_method(:confiscation_price, &->{{'russian codebook' => 5, 'wild card' => 50}})
      let(:calling_method) do
        ->(target_player, equipment) do
          confiscate_materials.(
            player_model:    player_model,
            change_orders:   change_orders,
            opponent_models: opponent_models,
            action_hash:     action_hash.(target_player, equipment)
          )
        end
      end
      %w(french german spanish italian american russian).each do |nationality|
        %w(password codebook disguise key).each do |type|
          equipment = "#{nationality} #{type}"
          describe "when equipment is '#{equipment}' it" do
            it 'returns the equipment confiscated' do
              expect(calling_method.('seat_2', equipment)).to eq(equipment)
            end
          end
        end
      end

      it 'calls change_orders#add_equipment_action once' do
        calling_method.('seat_2', 'russian password')
        expect(change_orders.times_called[:add_equipment_action]).to eql(1)
      end

      it 'calls change_orders#subtract_money_action once' do
        calling_method.('seat_2', 'russian password')
        expect(change_orders.times_called[:subtract_money_action]).to eql(1)
      end

      it 'calls change_orders#subtract_equipment_action once' do
        calling_method.('seat_2', 'russian password')
        expect(change_orders.times_called[:subtract_equipment_action]).to eql(1)
      end

      it 'calls change_orders#add_money_action once' do
        calling_method.('seat_2', 'russian password')
        expect(change_orders.times_called[:add_money_action]).to eql(1)
      end

      it 'calls change_orders#add_action once' do
        calling_method.('seat_2', 'russian password')
        expect(change_orders.times_called[:add_action]).to eql(1)
      end

      it 'targets the correct player with change_orders#add_equipment_action' do
        calling_method.('seat_2', 'russian password')
        expect(change_orders.target[:add_equipment_action]).to eql(player_model.seat)
      end

      it 'targets the correct player with change_orders#subtract_money_action' do
        calling_method.('seat_2', 'russian password')
        expect(change_orders.target[:subtract_money_action]).to eql(player_model.seat)
      end

      it 'targets the correct player with change_orders#subtract_equipment_action' do
        calling_method.('seat_2', 'russian password')
        expect(change_orders.target[:subtract_equipment_action]).to eql(opponent_models.first.seat)
      end

      it 'targets the correct player with change_orders#add_money_action' do
        calling_method.('seat_2', 'russian password')
        expect(change_orders.target[:add_money_action]).to eql(opponent_models.first.seat)
      end
    end
  end
end

