# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Validator::BuyEquipmentValidator do
  describe '#call' do
    let(:validate){
      SpyAlleyApplication::Validator::BuyEquipmentValidator::new(
        buyable_equipment: ['french codebook', 'german codebook', 'spanish codebook'],
        buy_limit:         2
      )
    }
    describe 'choosing to pass' do
      it 'will validate correctly when simply choosing to pass' do
        expect(validate.(player_action: 'pass')).to be_success
      end

      it 'will fail if you choose to pass, and equipment_to_buy is set' do
        expect(validate.(player_action: 'pass', equipment_to_buy: ['french codebook'])).to be_failure
      end
    end
    describe 'choosing to buy equipment' do
      it 'will validate correctly when choosing to buy a single valid equipment' do
        expect(validate.(player_action: 'buy_equipment', equipment_to_buy: ['french codebook'])).to be_success
      end

      it 'will validate correctly when choosing to buy multiple valid equipments within the buy limit' do
        expect(
          validate.(
            player_action:    'buy_equipment',
            equipment_to_buy: ['french codebook', 'german codebook']
          )
        ).to be_success
      end

      it 'will fail when choosing to buy multiple valid equipments beyond the buy limit' do
        expect(
          validate.(
            player_action:    'buy_equipment',
            equipment_to_buy: ['french codebook', 'german codebook', 'spanish codebook']
          )
        ).to be_failure
      end

      it 'will fail when choosing to buy a single invalid equipment' do
        expect(validate.(player_action: 'buy_equipment', equipment_to_buy: ['invalid equipment'])).to be_failure
      end

      it 'will fail when choosing to buy multiple equipments within the buy limit, one of which is invalid' do
        expect(
          validate.(
            player_action:    'buy_equipment',
            equipment_to_buy: ['french codebook', 'invalid equipment']
          )
        ).to be_failure
      end
    end
  end
end
