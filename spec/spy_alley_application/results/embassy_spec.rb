# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::Embassy do
  nationalities = %w(french german spanish italian american russian)
  equipment = %w(password, disguise, codebook, key)
  all_equipment = nationalities.map{|n| equipment.map{|e| "#{n} #{e}"}}.flatten
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:embassy, &->{SpyAlleyApplication::Results::Embassy::new})
  describe '#call' do
    nationalities.each.with_index do |nationality, index|
      [true, false].each do |same_embassy_as_player|
        (0..4).each do |num_equipment_owned|
          (0..2).each do |wild_cards|
            equipment = all_equipment - (4 - num_equipment_owned).times.map do |i|
              "#{nationality} #{equipment[i]}"
            end
            spy_identity = nationalities[same_embassy_as_player ? index : index + 1 % nationalities.length]
            let(:player_model) do
              PlayerMock.new(
                equipment: equipment,
                wild_cards: wild_cards,
                spy_identity: spy_identity
              )
            end
            win = (num_equipment_owned + wild_cards >= 4) && same_embassy_as_player
            describe "when the player is #{'not ' unless same_embassy_as_player}the same nationality " +
              "as the embassy at the #{nationality} embassy with #{num_equipment_owned} equipment owned " +
              "and #{wild_cards} wild card#{'s' unless wild_cards.eql?(1)} player is the #{spy_identity}" do

              if win
                it 'calls change_orders#add_game_victory' do
                  expect{
                    embassy.(
                      player_model: player_model,
                      change_orders: change_orders,
                      nationality: nationality
                    )
                  }.to change{change_orders.times_called[:add_game_victory]}.by(1)
                end
                it 'returns true' do
                  expect(
                    embassy.(
                      player_model: player_model,
                      change_orders: change_orders,
                      nationality: nationality
                    )
                  ).to be true
                end
              else
                it 'does not call change_orders#add_game_victory' do
                  expect{
                    embassy.(
                      player_model: player_model,
                      change_orders: change_orders,
                      nationality: nationality
                    )
                  }.not_to change{change_orders.times_called[:add_game_victory]}
                end
                it 'returns false' do
                  expect(
                    embassy.(
                      player_model: player_model,
                      change_orders: change_orders,
                      nationality: nationality
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
end
