# frozen string_literal: true

require 'dry-initializer'
require 'spy_alley_application/models/player'
require 'spy_alley_application/models/board_spaces/black_market'
require 'spy_alley_application/models/board_spaces/border_crossing'
require 'spy_alley_application/models/board_spaces/buy_equipment'
require 'spy_alley_application/models/board_spaces/buy_password'
require 'spy_alley_application/models/board_spaces/confiscate_materials'
require 'spy_alley_application/models/board_spaces/draw_free_gift'
require 'spy_alley_application/models/board_spaces/draw_move_card'
require 'spy_alley_application/models/board_spaces/embassy'
require 'spy_alley_application/models/board_spaces/move_back'
require 'spy_alley_application/models/board_spaces/sold_top_secret_information'
require 'spy_alley_application/models/board_spaces/spy_alley_entrance'
require 'spy_alley_application/models/board_spaces/spy_eliminator'
require 'spy_alley_application/models/board_spaces/start'
require 'spy_alley_application/models/board_spaces/take_another_turn'

start_space = SpyAlleyApplication::Models::BoardSpaces::Start::new(id: 0) do |start_space|
  junction_space = SpyAlleyApplication::Models::BoardSpaces::DrawMoveCard::new(id: 22,
    next_space: SpyAlleyApplication::Models::BoardSpaces::BlackMarket::new(id: 23,
    next_space: start_space))

  spy_alley_entrance = SpyAlleyApplication::Models::BoardSpaces::SpyAlleyEntrance::new(id: 14,
    next_space: SpyAlleyApplication::Models::BoardSpaces::SoldTopSecretInformation::new(id: 24,
      in_spy_alley: true,
      money_gained: 20,
    next_space: SpyAlleyApplication::Models::BoardSpaces::SpyEliminator::new(id: 25,
    next_space: SpyAlleyApplication::Models::BoardSpaces::Embassy::new(id: 26,
      nationality: 'french',
    next_space: SpyAlleyApplication::Models::BoardSpaces::Embassy::new(id: 27,
      nationality: 'german',
    next_space: SpyAlleyApplication::Models::BoardSpaces::ConfiscateMaterials::new(id: 28,
    next_space: SpyAlleyApplication::Models::BoardSpaces::Embassy::new(id: 29,
      nationality: 'spanish',
    next_space: SpyAlleyApplication::Models::BoardSpaces::Embassy::new(id: 30,
      nationality: 'italian',
    next_space: SpyAlleyApplication::Models::BoardSpaces::Embassy::new(id: 31,
      nationality: 'american',
    next_space: SpyAlleyApplication::Models::BoardSpaces::Embassy::new(id: 32,
      nationality: 'russian',
      next_space: junction_space)))))))))) do |spy_alley_entrance|
    SpyAlleyApplication::Models::BoardSpaces::BorderCrossing::new(id: 15,
      next_space: SpyAlleyApplication::Models::BoardSpaces::MoveBack::new(id: 16,
        move_back_space: spy_alley_entrance,
      next_space: SpyAlleyApplication::Models::BoardSpaces::BuyPassword::new(id: 17,
        nationality: 'german',
      next_space: SpyAlleyApplication::Models::BoardSpaces::BuyEquipment::new(id: 18,
        equipment_type: 'codebook',
      next_space: SpyAlleyApplication::Models::BoardSpaces::DrawMoveCard::new(id: 19,
      next_space: SpyAlleyApplication::Models::BoardSpaces::DrawFreeGift::new(id: 20,
      next_space: SpyAlleyApplication::Models::BoardSpaces::BuyPassword::new(id: 21,
        nationality: 'french',
        next_space: junction_space)))))))
  end

  SpyAlleyApplication::Models::BoardSpaces::BuyPassword::new(id: 1, nationality: 'russian',
    next_space: SpyAlleyApplication::Models::BoardSpaces::DrawMoveCard::new(id: 2,
    next_space: SpyAlleyApplication::Models::BoardSpaces::BuyEquipment::new(id: 3,
      equipment_type: 'disguise',
    next_space: SpyAlleyApplication::Models::BoardSpaces::BuyPassword::new(id: 4,
      nationality: 'american',
    next_space: SpyAlleyApplication::Models::BoardSpaces::DrawMoveCard::new(id: 5,
    next_space: SpyAlleyApplication::Models::BoardSpaces::TakeAnotherTurn::new(id: 6,
    next_space: SpyAlleyApplication::Models::BoardSpaces::DrawFreeGift::new(id: 7,
    next_space: SpyAlleyApplication::Models::BoardSpaces::SoldTopSecretInformation::new(id: 8,
      in_spy_alley: false,
      money_gained: 10,
    next_space: SpyAlleyApplication::Models::BoardSpaces::BuyPassword::new(id: 9,
      nationality: 'italian',
    next_space: SpyAlleyApplication::Models::BoardSpaces::BuyEquipment::new(id: 10,
      equipment_type: 'key',
    next_space: SpyAlleyApplication::Models::BoardSpaces::BuyPassword::new(id: 11,
      nationality: 'spanish',
    next_space: SpyAlleyApplication::Models::BoardSpaces::DrawMoveCard::new(id: 12,
    next_space: SpyAlleyApplication::Models::BoardSpaces::BlackMarket::new(id: 13,
      next_space: spy_alley_entrance)))))))))))))
end
spaces = [start_space]
(0..13).to_a.each do |i|
  spaces.push(spaces.last.next_space)
end
spaces.push(spaces.last.branch_space)
(15..22).to_a.each do |i|
  spaces.push(spaces.last.next_space)
end
spaces.push(spaces[14].next_space)
(24..31).to_a.each do |i|
  spaces.push(spaces.last.next_space)
end

loc_type = Dry::Struct(id: Types::Coercible::Integer)

i = Class::new do
  include Dry::Initializer.define -> do
    param :game_board_spaces, type: ::Types::Array::of(SpyAlleyApplication::Types::BoardSpace)
    param :location_type, type: ::Types::Callable
  end

  def call(player)
    player[:location] = game_board_spaces[location_type.(player[:location]).id]
    player = player.map{|k, v| [k.eql?(:active?) ? :active : k, v]}.to_h
    player = SpyAlleyApplication::Models::Player.(player)
    all_equipment_distinct(player, player.equipment)
    player
  end

  private
  def all_equipment_distinct(player, equipment)
    equipment_list = []
    equipment.each do |equip|
      equip_name = "#{equip.nationality} #{equip.type}"
      if equipment_list.include?(equip_name)
        raise Dry::Types::ConstraintError::new(
          'All equipment for player is distinct', "player: #{player}, equipment: #{equipment}")
      end
      equipment_list.push equip_name
    end
  end
end.new(spaces, loc_type)
SpyAlleyApplication::Types::Player = ::Types::Constructor(Class){|value| i.call(value)}

