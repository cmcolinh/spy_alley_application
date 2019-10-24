# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::BuyEquipment::Keys do
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:do_nothing, &->{CallableStub::new})
  let(:buy_equipment, &->{CallableStub::new})
  let(:buy_keys) do
    SpyAlleyApplication::Results::BuyEquipment::Keys::new(
      do_nothing: do_nothing,
      buy_equipment: buy_equipment
    )
  end
  it 'calls do_nothing if the player has no money' do
    player_model = PlayerMock::new(money: 0, equipment: [])
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(do_nothing.called_with).not_to eql({})
  end
  it 'does not call buy_equipment if the player has no money' do
    player_model = PlayerMock::new(money: 0, equipment: [])
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with).to eql({})
  end
  it 'calls do_nothing if the player already has all of the keys' do
    player_model = PlayerMock::new(
      money: 50,
      equipment: [
        'french key',
        'german key',
        'spanish key',
        'italian key',
        'american key',
        'russian key'
      ]
    )
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(do_nothing.called_with).not_to eql({})
  end
  it 'does not call buy_equipment if the player already has all of the keys' do
    player_model = PlayerMock::new(
      money: 50,
      equipment: [
        'french key',
        'german key',
        'spanish key',
        'italian key',
        'american key',
        'russian key'
      ]
    )
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with).to eql({})
  end
  it 'does calls buy_equipment offering to buy any of the unowned keys if the player has ' +
    'at least 30 money and does not own all of the keys' do

    player_model = PlayerMock::new(money: 30, equipment: ['french key', 'german key'])
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_options]).to match_array([
      'spanish key',
      'italian key',
      'american key',
      'russian key'
    ])
  end
  it 'does calls buy_equipment giving a buy limit of 1 if the player has between 30 and 59 money ' +
    'and does not have all of the keys' do

    player_model = PlayerMock::new(money: 30, equipment: ['french key', 'german key'])
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
  end
  it 'does calls buy_equipment giving a buy limit of 2 if the player has between 60 and 89 money ' +
    'and is missing at least two keys' do

    player_model = PlayerMock::new(money: 60, equipment: ['french key', 'german key'])
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(2)
  end
  it 'does calls buy_equipment giving a buy limit of 3 if the player has between 90 and 119 money ' +
    'and is missing at least three keys' do

    player_model = PlayerMock::new(money: 90, equipment: ['french key', 'german key'])
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(3)
  end
  it 'does calls buy_equipment giving a buy limit of 4 if the player has between 120 and 149 money ' +
    'and is missing at least four keys' do

    player_model = PlayerMock::new(money: 120, equipment: ['french key'])
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(4)
  end
  it 'does calls buy_equipment giving a buy limit of 5 if the player has between 150 and 179 money ' +
    'and is missing at least five keys' do

    player_model = PlayerMock::new(money: 25, equipment: ['french password'])
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(5)
  end
  it 'does calls buy_equipment giving a buy limit of 6 if the player has at least 180 money ' +
    'and does not have any keys' do

    player_model = PlayerMock::new(money: 200, equipment: ['french password'])
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(6)
  end
  it 'does calls buy_equipment giving a buy limit of 1 if the player has enough money to buy all ' +
    'of the keys, but is only missing one of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french key',
        'german key',
        'italian key',
        'american key',
        'russian key'
      ]
    )
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
  end
  it 'does calls buy_equipment giving a buy limit of 2 if the player has enough money to buy all ' +
    'of the keys, but is only missing two of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french key',
        'italian key',
        'american key',
        'russian key'
      ]
    )
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(2)
  end
  it 'does calls buy_equipment giving a buy limit of 3 if the player has enough money to buy all ' +
    'of the keys, but is only missing three of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french key',
        'italian key',
        'russian key'
      ]
    )
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(3)
  end
  it 'does calls buy_equipment giving a buy limit of 4 if the player has enough money to buy all ' +
    'of the keys, but is only missing four of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'french key',
        'russian key'
      ]
    )
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(4)
  end
  it 'does calls buy_equipment giving a buy limit of 5 if the player has enough money to buy all ' +
    'of the keys, but is only missing five of them' do

    player_model = PlayerMock::new(
      money: 200,
      equipment: [
        'french password',
        'russian key'
      ]
    )
    buy_keys.(
      player_model: player_model,
      change_orders: change_orders,
      action_hash:  action_hash
    )
    expect(buy_equipment.called_with[:purchase_limit]).to eql(5)
  end
end
