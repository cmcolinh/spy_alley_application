# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::Embassy do
  nationalities = %w(french german spanish italian american russian)
  equipment = %w(password, disguise, codebook, key)
  german_set = equipment.map{|e| "german #{e}"}
  all_equipment = nationalities.map{|n| equipment.map{|e| "#{n} #{e}"}}.flatten
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:embassy, &->{SpyAlleyApplication::Results::Embassy::new})
  describe '#call' do
    [true, false].each do |same_embassy_as_player|
      (0..4).each do |num_equipment_owned|
        (0..2).each do |wild_cards|
          spy_identity = same_embassy_as_player ? 'french' : 'german'
          equipment_owned = german_set + num_equipment_owned.times.map.with_index do |e, i|
            "french #{e}"
          end
          let(:player_model) do
            PlayerMock.new(
              equipment: equipment_owned,
              wild_cards: wild_cards,
              spy_identity: spy_identity
            )
          end
          win = (num_equipment_owned + wild_cards >= 4) && same_embassy_as_player
          describe "when the player is #{'not ' unless same_embassy_as_player}the same nationality " +
            "as the embassy with #{num_equipment_owned} equipment owned " +
            "and #{wild_cards} wild card#{'s' unless wild_cards.eql?(1)}" do

            if win
              it 'calls change_orders#add_game_victory' do
                expect{
                  embassy.(
                    player_model: player_model,
                    change_orders: change_orders,
                    nationality: 'french'
                  )
                }.to change{change_orders.times_called[:add_game_victory]}.by(1)
              end
              it 'returns true' do
                expect(
                  embassy.(
                    player_model: player_model,
                    change_orders: change_orders,
                    nationality: 'french'
                  )
                ).to be true
              end
            else
              it 'does not call change_orders#add_game_victory' do
                expect{
                  embassy.(
                    player_model: player_model,
                    change_orders: change_orders,
                    nationality: 'french'
                  )
                }.not_to change{change_orders.times_called[:add_game_victory]}
              end
              it 'returns false' do
                expect(
                  embassy.(
                    player_model: player_model,
                    change_orders: change_orders,
                    nationality: 'french'
                  )
                ).to be false
              end
            end
          end
        end
      end
     end
  end
end
