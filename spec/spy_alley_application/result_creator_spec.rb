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
        expect(create_result.(space_to_move: '1')).to(
          be_a(SpyAlleyApplication::Results::BuyEquipment::RussianPassword))
      end
    end
    describe "landing on space '2'" do
      it "returns a SpyAlleyApplication::Results::DrawMoveCard when landing on space '2'" do
        expect(create_result.(space_to_move: '2')).to be_a SpyAlleyApplication::Results::DrawMoveCard
      end
    end
    describe "landing on space '3'" do
      it "returns a SpyAlleyApplication::Results::BuyEquipment::Disguises when landing on space '3'" do
        expect(create_result.(space_to_move: '3')).to(
          be_a(SpyAlleyApplication::Results::BuyEquipment::Disguises))
      end
    end
    describe "landing on space '4'" do
      it "returns a SpyAlleyApplication::Results::BuyEquipment::AmericanPassword when landing on space '4'" do
        expect(create_result.(space_to_move: '4')).to(
          be_a(SpyAlleyApplication::Results::BuyEquipment::AmericanPassword))
      end
    end
    describe "landing on space '5'" do
      it "returns a SpyAlleyApplication::Results::DrawMoveCard when landing on space '5'" do
        expect(create_result.(space_to_move: '5')).to be_a SpyAlleyApplication::Results::DrawMoveCard
      end
    end
    describe "landing on space '6'" do
      it "returns a SpyAlleyApplication::Results::TakeAnotherTurn when landing on space '6'" do
        expect(create_result.(space_to_move: '6')).to(
          be_a(SpyAlleyApplication::Results::TakeAnotherTurn))
      end
    end
    describe "landing on space '7'" do
      it "returns a SpyAlleyApplication::Results::DrawFreeGift when landing on space '7'" do
        expect(create_result.(space_to_move: '7')).to be_a SpyAlleyApplication::Results::DrawFreeGift
      end
    end
    describe "landing on space '8'" do
      it "returns a SpyAlleyApplication::Results::SoldTopSecretInformation::Ten when landing on space '8'" do
        expect(create_result.(space_to_move: '8')).to(
          be_a(SpyAlleyApplication::Results::SoldTopSecretInformation::Ten))
      end
    end
    describe "landing on space '9'" do
      it "returns a SpyAlleyApplication::Results::BuyEquipment::ItalianPassword when landing on space '9'" do
        expect(create_result.(space_to_move: '9')).to(
          be_a(SpyAlleyApplication::Results::BuyEquipment::AmericanPassword))
      end
    end
    describe "landing on space '10'" do
      it "returns a SpyAlleyApplication::Results::BuyEquipment::Keys when landing on space '10'" do
        expect(create_result.(space_to_move: '10')).to(
          be_a(SpyAlleyApplication::Results::BuyEquipment::Keys))
      end
    end
    describe "landing on space '11'" do
      it "returns a SpyAlleyApplication::Results::BuyEquipment::SpanishPassword when landing on space '11'" do
        expect(create_result.(space_to_move: '11')).to(
          be_a(SpyAlleyApplication::Results::BuyEquipment::SpanishPassword))
      end
    end
    describe "landing on space '12'" do
      it "returns a SpyAlleyApplication::Results::DrawMoveCard when landing on space '12'" do
        expect(create_result.(space_to_move: '12')).to be_a SpyAlleyApplication::Results::DrawMoveCard
      end
    end
    describe "landing on space '13'" do
      it "returns a SpyAlleyApplication::Results::BuyEquipment::BlackMarket when landing on space '13'" do
        expect(create_result.(space_to_move: '13')).to(
          be_a(SpyAlleyApplication::Results::BuyEquipment::BlackMarket))
      end
    end
    describe "landing on space '14'" do
      it "returns a SpyAlleyApplication::Results::NoActionResult when landing on space '14'" do
        expect(create_result.(space_to_move: '14')).to be_a SpyAlleyApplication::Results::NoActionResult
      end
    end
    describe "landing on space '15'" do
      it "returns a SpyAlleyApplication::Results::BorderCrossing when landing on space '15'" do
        expect(create_result.(space_to_move: '15')).to be_a SpyAlleyApplication::Results::BorderCrossing
      end
    end
    describe "landing on space '16'" do
      it "returns a SpyAlleyApplication::Results::MoveBackTwoSpaces when landing on space '16'" do
        expect(create_result.(space_to_move: '16')).to be_a SpyAlleyApplication::Results::MoveBackTwoSpaces
      end
    end
    describe "landing on space '17'" do
      it "returns a SpyAlleyApplication::Results::BuyEquipment::GermanPassword when landing on space '17'" do
        expect(create_result.(space_to_move: '17')).to(
          be_a(SpyAlleyApplication::Results::BuyEquipment::GermanPassword))
      end
    end
    describe "landing on space '18'" do
      it "returns a SpyAlleyApplication::Results::BuyEquipment::Keys when landing on space '18'" do
        expect(create_result.(space_to_move: '18')).to(
          be_a(SpyAlleyApplication::Results::BuyEquipment::Codebooks))
      end
    end
    describe "landing on space '19'" do
      it "returns a SpyAlleyApplication::Results::DrawMoveCard when landing on space '19'" do
        expect(create_result.(space_to_move: '19')).to be_a SpyAlleyApplication::Results::DrawMoveCard
      end
    end
    describe "landing on space '20'" do
      it "returns a SpyAlleyApplication::Results::DrawFreeGift when landing on space '20'" do
        expect(create_result.(space_to_move: '20')).to be_a SpyAlleyApplication::Results::DrawFreeGift
      end
    end
    describe "landing on space '21'" do
      it "returns a SpyAlleyApplication::Results::BuyEquipment::FrenchPassword when landing on space '21'" do
        expect(create_result.(space_to_move: '21')).to(
          be_a(SpyAlleyApplication::BuyEquipment::FrenchPassword))
      end
    end
    describe "landing on space '22'" do
      it "returns a SpyAlleyApplication::Results::DrawMoveCard when landing on space '22'" do
        expect(create_result.(space_to_move: '22')).to be_a SpyAlleyApplication::Results::DrawMoveCard
      end
    end
    describe "landing on space '23'" do
      it "returns a SpyAlleyApplication::Results::BuyEquipment::BlackMarket when landing on space '23'" do
        expect(create_result.(space_to_move: '23')).to(
          be_a(SpyAlleyApplication::BuyEquipment::BlackMarket))
      end
    end
    describe "landing on space '1s'" do
      it "returns a SpyAlleyApplication::Results::SoldTopSecretInformation::Twenty when landing on space '1s'" do
        expect(create_result.(space_to_move: '1s')).to(
          be_a(SpyAlleyApplication::Results::SoldTopSecretInformation::Twenty))
      end
    end
    describe "landing on space '2s'" do
      it "returns a SpyAlleyApplication::Results::SpyEliminator when landing on space '2s'" do
        expect(create_result.(space_to_move: '2s')).to be_a SpyAlleyApplication::Results::SpyEliminator
      end
    end
    describe "landing on space '3s'" do
      it "returns a SpyAlleyApplication::Results::Embassy::French when landing on space '3s'" do
        expect(create_result.(space_to_move: '3s')).to(
          be_a(SpyAlleyApplication::Results::Embassy::French))
      end
    end
    describe "landing on space '4s'" do
      it "returns a SpyAlleyApplication::Results::Embassy::German when landing on space '4s'" do
        expect(create_result.(space_to_move: '4s')).to(
          be_a(SpyAlleyApplication::Results::Embassy::German))
      end
    end
    describe "landing on space '5s'" do
      it "returns a SpyAlleyApplication::Results::ConfiscateMaterials when landing on space '5s'" do
        expect(create_result.(space_to_move: '5s')).to be_a SpyAlleyApplication::Results::ConfiscateMaterials
      end
    end
    describe "landing on space '6s'" do
      it "returns a SpyAlleyApplication::Results::Embassy::Spanish when landing on space '6s'" do
        expect(create_result.(space_to_move: '6s')).to(
          be_a(SpyAlleyApplication::Results::Embassy::Spanish))
      end
    end
    describe "landing on space '7s'" do
      it "returns a SpyAlleyApplication::Results::Embassy::Italian when landing on space '7s'" do
        expect(create_result.(space_to_move: '7s')).to(
          be_a(SpyAlleyApplication::Results::Embassy::Italian))
      end
    end
    describe "landing on space '8s'" do
      it "returns a SpyAlleyApplication::Results::Embassy::American when landing on space '8s'" do
        expect(create_result.(space_to_move: '8s')).to(
          be_a(SpyAlleyApplication::Results::Embassy::American))
      end
    end
    describe "landing on space '9s'" do
      it "returns a SpyAlleyApplication::Results::Embassy::Russian when landing on space '9s'" do
        expect(create_result.(space_to_move: '9s')).to(
          be_a(SpyAlleyApplication::Results::Embassy::Russian))
      end
    end
  end
end
