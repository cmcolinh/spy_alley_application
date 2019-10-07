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
      it "returns a SpyAlleyApplication::Results::BuyEquipmentOption when landing on space '0'" do
        expect(create_result.(space_to_move: '0')).to be_a SpyAlleyApplication::Results::BuyEquipmentOption
      end
    end
  end
end
