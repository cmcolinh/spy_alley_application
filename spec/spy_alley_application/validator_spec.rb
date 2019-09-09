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
  end
end