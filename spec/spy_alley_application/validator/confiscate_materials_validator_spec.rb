# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Validator::ConfiscateMaterialsValidator do
  describe '#call' do
    let(:validate){
      SpyAlleyApplication::Validator::ConfiscateMaterialsValidator::new(
        selectable_options: {
          'seat_2' => ['french codebook', 'german codebook', 'spanish codebook'],
          'seat_3' => ['russian key', 'wild card']
        }
      )
    }
    describe 'choosing to pass' do
      it 'will validate correctly when simply choosing to pass' do
        expect(validate.(player_action: 'pass')).to be_success
      end

      it 'will fail if you choose to pass, and equipment_to_confiscate is set' do
        expect(
          validate.(
            player_action: 'pass',
            player_to_confiscate_from: 'seat_2',
            equipment_to_confiscate: 'french codebook'
          )
        ).to be_failure
      end
    end

    describe 'choosing to confiscate materials' do
      it 'will validate correctly when choosing to confiscate valid equipment' do
        expect(
          validate.(
            player_action:             'confiscate_materials',
            player_to_confiscate_from: 'seat_2',
            equipment_to_confiscate:   'french codebook'
          )
        ).to be_success
      end

      it 'will fail when attempting to confiscate multiple valid equipments' do
        expect(
          validate.(
            player_action:             'confiscate_materials',
            player_to_confiscate_from: 'seat_2',
            equipment_to_confiscate:   ['french codebook', 'german codebook']
          )
        ).to be_failure
      end

      it 'will fail when failing to specify a player to confiscate from' do
        expect(
          validate.(
            player_action:             'confiscate_materials',
            equipment_to_confiscate:   'german codebook'
          )
        ).to be_failure
      end

      it 'will fail when failing to specify equipment to confiscate' do
        expect(
          validate.(
            player_action:             'confiscate_materials',
            player_to_confiscate_from: 'seat_2',
          )
        ).to be_failure
      end

      it 'will fail when attempting to confiscate materials that applies to a different target' do
        expect(
          validate.(
            player_action:             'confiscate_materials',
            player_to_confiscate_from: 'seat_3',
            equipment_to_confiscate:   'german codebook'
          )
        ).to be_failure
      end
    end
  end
end
