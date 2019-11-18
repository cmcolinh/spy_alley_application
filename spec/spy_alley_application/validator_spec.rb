# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Validator do
  let(:validator_for) do
    ->(options) do
      SpyAlleyApplication::Validator::new(options)
    end
  end
  let(:all_nationalities){%s(french german spanish italian american russian)}
  describe '#new' do
    describe 'when options are to roll or make accusation' do
      let(:options) do 
        { accept_roll:            true,
          accept_make_accusation: {player: 'seat_1', nationality: all_nationalities}
        }
      end
      it 'creates the correct type of validator for this case' do
        expect(validator_for.(options)).to be_a(SpyAlleyApplication::Validator::RollNoMoveCardValidator)
      end
    end
    describe 'when options are to roll, use move card or make accusation' do
      let(:options) do 
        { accept_roll:            true,
          accept_use_move_card:   [1, 2],
          accept_make_accusation: {player: 'seat_1', nationality: all_nationalities}
        }
      end
      it 'creates the correct type of validator for this case' do
        expect(validator_for.(options)).to be_a(SpyAlleyApplication::Validator::RollOrMoveCardValidator)
      end
    end
    describe 'when options are to buy equipment or pass' do
      let(:options) do 
        { accept_pass:          true,
          accept_buy_equipment: {equipment: 'american password', limit: 1}
        }
      end
      it 'creates the correct type of validator for this case' do
        expect(validator_for.(options)).to be_a(SpyAlleyApplication::Validator::BuyEquipmentValidator)
      end
    end
    describe 'when options are to choose one of two locations to move' do
      let(:options) do 
        { accept_move: ['18', '2s']}
      end
      it 'creates the correct type of validator for this case' do
        expect(validator_for.(options)).to be_a(SpyAlleyApplication::Validator::MoveValidator)
      end
    end
    describe 'when options are to make an accusation or pass' do
      let(:options) do 
        { accept_pass: true,
          accept_make_accusation: {player: 'seat_1', nationality: all_nationalities}
        }
      end
      it 'creates the correct type of validator for this case' do
        expect(validator_for.(options)).to be_a(SpyAlleyApplication::Validator::SpyEliminatorValidator)
      end
    end
    describe 'when options are to confiscate materials or pass' do
      let(:options) do 
        { accept_pass: true,
          accept_confiscate_materials: ['russian password', 'american password']
        }
      end
      it 'creates the correct type of validator for this case' do
        expect(validator_for.(options)).to be_a(SpyAlleyApplication::Validator::ConfiscateMaterialsValidator)
      end
    end
    describe 'when options are to choose a new spy identity' do
      let(:options) do 
        { accept_choose_new_identity: ['french', 'german'] }
      end
      it 'creates the correct type of validator for this case' do
        expect(validator_for.(options)).to be_a(SpyAlleyApplication::Validator::ChooseNewIdentityValidator)
      end
    end
  end
end
