# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::ResultCreator do
  let(:create_result, &->{SpyAlleyApplication::ResultCreator::new})
  describe '#call' do
    describe "landing on space '0'" do
      it "returns a SpyAlleyApplication::Results::NoActionResult when landing on space '0'" do
        expect(create_result.(space_to_move: '0')).to be_a SpyAlleyApplication::Results::NoActionResult
      end
    end
    describe "landing on space '1'" do
      describe 'when player has no money' do
        let(:player_model, &->{PlayerMock::new(money: 0, equipment: [])})
        it 'returns a SpyAlleyApplication::Results::NoActionResult' do
          expect(create_result.(space_to_move: '1')).to be_a SpyAlleyApplication::Results::NoActionResult
        end
      end
      describe 'when player has money, but already has the russian password' do
        let(:player_model, &->{PlayerMock::new(money: 0, equipment: ['russian password'])})
        it 'returns a SpyAlleyApplication::Results::NoActionResult' do
          expect(create_result.(space_to_move: '1')).to be_a SpyAlleyApplication::Results::NoActionResult
        end
      end
      describe 'when player has money, and does not have the russian password' do
        let(:player_model, &->{PlayerMock::new(money: 1, equipment: ['russian codebook'])})
        it 'returns a SpyAlleyApplication::Results:BuyEquipmentOption' do
          expect(create_result.(space_to_move: '1')).to be_a SpyAlleyApplication::Results::BuyEquipmentOption
        end
        it 'returns a SpyAlleyApplication::Results:BuyEquipmentOption' do
          expect(create_result.(space_to_move: '1')).to be_a SpyAlleyApplication::Results::BuyEquipmentOption
        end
        it 'has the option only to buy the russian password' do
          expect(create_result.(space_to_move: '1').equipment_to_buy).to match_array(['russian password'])
        end
        it 'has a buy limit of 1' do
          expect(create_result.(space_to_move: '1').buy_limit).to eql 1
        end
      end
    end
  end
end
