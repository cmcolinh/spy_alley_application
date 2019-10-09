# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::ResultCreator do
  let(:all_equipment) do
    %w(password disguise codebook key).map do |equipment|
      %w(french german spanish italian american russian).map do |nationality|
        "#{nationality} #{equipment}"
      end
    end.flatten
  end
  let(:create_result, &->{SpyAlleyApplication::ResultCreator::new})
  describe '#call' do
    describe "landing on space '0'" do
      it "returns a SpyAlleyApplication::Results::NoActionResult when landing on space '0'" do
        expect(create_result.(space_to_move: '0')).to be_a SpyAlleyApplication::Results::NoActionResult
      end
    end
    describe "landing on space '1'" do
      it "returns a SpyAlleyApplication::Results::BuyEquipment::RussianPassword when landing on space '1'" do
        expect(create_result.(space_to_move: '0')).to
          be_a SpyAlleyApplication::BuyEquipment::RussianPassword
      end
    end
    describe "landing on space '2'" do
      it "returns a SpyAlleyApplication::Results::DrawMoveCard when landing on space '0'" do
        expect(create_result.(space_to_move: '0')).to be_a SpyAlleyApplication::Results::DrawMoveCard
      end
    end
    describe "landing on space '3'" do

    end
    describe "landing on space '4'" do
    end
    describe "landing on space '5'" do
    end
    describe "landing on space '6'" do
    end
    describe "landing on space '7'" do
    end
    describe "landing on space '8'" do
    end
    describe "landing on space '9'" do
    end
    describe "landing on space '10'" do
    end
    describe "landing on space '11'" do
    end
    describe "landing on space '12'" do
    end
    describe "landing on space '13'" do
    end
    describe "landing on space '14'" do
    end
    describe "landing on space '15'" do
    end
    describe "landing on space '16'" do
    end
    describe "landing on space '17'" do
    end
    describe "landing on space '18'" do
    end
    describe "landing on space '19'" do
    end
    describe "landing on space '20'" do
    end
    describe "landing on space '21'" do
    end
    describe "landing on space '22'" do
    end
    describe "landing on space '23'" do
    end
    describe "landing on space '1s'" do
    end
    describe "landing on space '2s'" do
    end
    describe "landing on space '3s'" do
    end
    describe "landing on space '4s'" do
    end
    describe "landing on space '5s'" do
    end
    describe "landing on space '6s'" do
    end
    describe "landing on space '7s'" do
    end
    describe "landing on space '8s'" do
    end
    describe "landing on space '9s'" do
    end
  end
end

