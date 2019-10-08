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
        it 'has the option only to buy the russian password' do
          expect(create_result.(space_to_move: '1').equipment_to_buy).to match_array(['russian password'])
        end
        it 'has a buy limit of 1' do
          expect(create_result.(space_to_move: '1').buy_limit).to eql 1
        end
      end
    end
    describe "landing on space '2'" do
      let(:player_model, &->{PlayerMock::new})
      it 'returns a SpyAlleyApplication::Results::DrawMoveCard' do
        expect(create_result.(space_to_move: '2')).to be_a SpyAlleyApplication::Results::DrawMoveCard
      end
    end
    describe "landing on space '3'" do
      let(:all_disguises, &->{all_equipment.filter{|e| e.include?('disguise')}})
      describe 'when player has no money' do
        let(:player_model, &->{PlayerMock::new(money: 0, equipment: [])})
        it 'returns a SpyAlleyApplication::Results::NoActionResult' do
          expect(create_result.(space_to_move: '3')).to be_a SpyAlleyApplication::Results::NoActionResult
        end
      end
      describe 'when player has enough to buy, but already owns all of the disguises' do
        let(:player_model, &->{PlayerMock::new(money: 5, equipment: all_disguises)})
        it 'returns a SpyAlleyApplication::Results::NoActionResult' do
          expect(create_result.(space_to_move: '3')).to be_a SpyAlleyApplication::Results::NoActionResult
        end
      end
      describe 'when player has enough money to buy some disguises, but not all unowned disguises' do
        let(:player_model, &->{PlayerMock::new(money: 15, equipment: [])})
        it 'returns a SpyAlleyApplication::Results:BuyEquipmentOption' do
          expect(create_result.(space_to_move: '3')).to be_a SpyAlleyApplication::Results::BuyEquipmentOption
        end
        it 'has the option to buy any disguise' do
          expect(create_result.(space_to_move: '3').equipment_to_buy).to match_array(all_disguises)
        end
        it 'has a buy limit of 3 due to money' do
          expect(create_result.(space_to_move: '3').buy_limit).to eql 3
        end
      end
      describe 'when player has enough money to buy all disguises, but some are already owned' do
        let(:player_model, &->{PlayerMock::new(
          money: 50,
          equipment: ['french disguise', 'german disguise', 'spanish disguise']
        )})
        it 'returns a SpyAlleyApplication::Results:BuyEquipmentOption' do
          expect(create_result.(space_to_move: '3')).to be_a SpyAlleyApplication::Results::BuyEquipmentOption
        end
        it 'has the option only to buy only unowned disguises' do
          expect(create_result.(space_to_move: '3').equipment_to_buy).to
            match_array(['italian disguise', 'american disguise', 'russian disguise'])
        end
        it 'has a buy limit of 3 due to owning the other three already' do
          expect(create_result.(space_to_move: '3').buy_limit).to eql 3
        end
      end
      describe 'when player has enough money to buy all disguises, and none are owned' do
        let(:player_model, &->{PlayerMock::new(money: 50, equipment: [])})
        it 'returns a SpyAlleyApplication::Results:BuyEquipmentOption' do
          expect(create_result.(space_to_move: '3')).to be_a SpyAlleyApplication::Results::BuyEquipmentOption
        end
        it 'has the option only to buy any disguise' do
          expect(create_result.(space_to_move: '3').equipment_to_buy).to match_array(all_disguises)
        end
        it 'has a buy limit of 6' do
          expect(create_result.(space_to_move: '3').buy_limit).to eql 6
        end
      end
    end
    describe "landing on space '4'" do
      describe 'when player has no money' do
        let(:player_model, &->{PlayerMock::new(money: 0, equipment: [])})
        it 'returns a SpyAlleyApplication::Results::NoActionResult' do
          expect(create_result.(space_to_move: '4')).to be_a SpyAlleyApplication::Results::NoActionResult
        end
      end
      describe 'when player has money, but already has the american password' do
        let(:player_model, &->{PlayerMock::new(money: 0, equipment: ['american password'])})
        it 'returns a SpyAlleyApplication::Results::NoActionResult' do
          expect(create_result.(space_to_move: '4')).to be_a SpyAlleyApplication::Results::NoActionResult
        end
      end
      describe 'when player has money, and does not have the american password' do
        let(:player_model, &->{PlayerMock::new(money: 1, equipment: ['american codebook'])})
        it 'returns a SpyAlleyApplication::Results:BuyEquipmentOption' do
          expect(create_result.(space_to_move: '4')).to be_a SpyAlleyApplication::Results::BuyEquipmentOption
        end
        it 'has the option only to buy the american password' do
          expect(create_result.(space_to_move: '4').equipment_to_buy).to match_array(['american password'])
        end
        it 'has a buy limit of 1' do
          expect(create_result.(space_to_move: '4').buy_limit).to eql 1
        end
      end
    end
    describe "landing on space '5'" do
      let(:player_model, &->{PlayerMock::new})
      it 'returns a SpyAlleyApplication::Results::DrawMoveCard' do
        expect(create_result.(space_to_move: '5')).to be_a SpyAlleyApplication::Results::DrawMoveCard
      end
    end
    describe "landing on space '6'" do
      let(:player_model, &->{PlayerMock::new})
      it 'returns a SpyAlleyApplication::Results::TakeAnotherTurn' do
        expect(create_result.(space_to_move: '6')).to be_a SpyAlleyApplication::Results::TakeAnotherTurn
      end
    end
    describe "landing on space '7'" do
      let(:player_model, &->{PlayerMock::new})
      it 'returns a SpyAlleyApplication::Results::DrawFreeGift' do
        expect(create_result.(space_to_move: '7')).to be_a SpyAlleyApplication::Results::DrawFreeGift
      end
    end
    describe "landing on space '8'" do
      let(:player_model, &->{PlayerMock::new})
      it 'returns a SpyAlleyApplication::Results::SoldTopSecretInformation' do
        expect(create_result.(space_to_move: '7')).to be_a SpyAlleyApplication::Results::SoldTopSecretInformation
      end
      it 'is set to give the player 10 money' do
        expect(create_result.(space_to_move: '7').money).to eql 10
ion
      end
    end
    describe "landing on space '9'" do
      describe 'when player has no money' do
        let(:player_model, &->{PlayerMock::new(money: 0, equipment: [])})
        it 'returns a SpyAlleyApplication::Results::NoActionResult' do
          expect(create_result.(space_to_move: '9')).to be_a SpyAlleyApplication::Results::NoActionResult
        end
      end
      describe 'when player has money, but already has the italian password' do
        let(:player_model, &->{PlayerMock::new(money: 0, equipment: ['italian password'])})
        it 'returns a SpyAlleyApplication::Results::NoActionResult' do
          expect(create_result.(space_to_move: '9')).to be_a SpyAlleyApplication::Results::NoActionResult
        end
      end
      describe 'when player has money, and does not have the italian password' do
        let(:player_model, &->{PlayerMock::new(money: 1, equipment: ['italian codebook'])})
        it 'returns a SpyAlleyApplication::Results:BuyEquipmentOption' do
          expect(create_result.(space_to_move: '9')).to be_a SpyAlleyApplication::Results::BuyEquipmentOption
        end
        it 'has the option only to buy the italian password' do
          expect(create_result.(space_to_move: '9').equipment_to_buy).to match_array(['italian password'])
        end
        it 'has a buy limit of 1' do
          expect(create_result.(space_to_move: '9').buy_limit).to eql 1
        end
      end
    end
  end
end
