# frozen_string_literal: true

RSpec.describe SpyAlleyApplication::Results::BuyEquipment::BlackMarket do
  let(:change_orders, &->{ChangeOrdersMock::new})
  let(:action_hash, &->{{player_action: 'roll'}})
  let(:do_nothing, &->{CallableStub::new})
  let(:buy_equipment, &->{CallableStub::new})
  let(:black_market) do
    SpyAlleyApplication::Results::BuyEquipment::BlackMarket::new(
      do_nothing: do_nothing,
      buy_equipment: buy_equipment
    )
  end
  describe 'player has no money' do
    it 'calls do_nothing if the player has no money' do
      player_model = PlayerMock::new(money: 0, equipment: [])
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(do_nothing.called_with).not_to eql({})
    end
    it 'does not call buy_equipment if the player has no money' do
      player_model = PlayerMock::new(money: 0, equipment: [])
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with).to eql({})
    end
  end
  describe 'player has between 1 and 4 money' do
    it 'calls do_nothing if the player already has all of the passwords' do
      player_model = PlayerMock::new(
        money: 4,
        equipment: [
          'french password',
          'german password',
          'spanish password',
          'italian password',
          'american password',
          'russian password'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(do_nothing.called_with).not_to eql({})
    end
    it 'does not call buy_equipment if the player already has all of the passwords' do
      player_model = PlayerMock::new(
        money: 4,
        equipment: [
          'french password',
          'german password',
          'spanish password',
          'italian password',
          'american password',
          'russian password'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with).to eql({})
    end
    it 'does calls buy_equipment offering to buy any of the unowned passwords the player has' do
      player_model = PlayerMock::new(money: 4, equipment: ['french password', 'german password'])
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with[:purchase_options]).to match_array([
        'spanish password',
        'italian password',
        'american password',
        'russian password'
      ])
    end
    it 'does calls buy_equipment giving a buy limit of 1' do
      player_model = PlayerMock::new(money: 4, equipment: ['french password', 'german password'])
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
    end
  end
  describe 'player has between 5 and 14 money' do
    it 'calls do_nothing if the player already has all of the passwords and all of the disguises' do
      player_model = PlayerMock::new(
        money: 14,
        equipment: [
          'french password',
          'german password',
          'spanish password',
          'italian password',
          'american password',
          'russian password',
          'french disguise',
          'german disguise',
          'spanish disguise',
          'italian disguise',
          'american disguise',
          'russian disguise'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(do_nothing.called_with).not_to eql({})
    end
    it 'does not call buy_equipment if the player already has all of the passwords and all of the disguises' do
      player_model = PlayerMock::new(
        money: 14,
        equipment: [
          'french password',
          'german password',
          'spanish password',
          'italian password',
          'american password',
          'russian password',
          'french disguise',
          'german disguise',
          'spanish disguise',
          'italian disguise',
          'american disguise',
          'russian disguise'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with).to eql({})
    end
    it 'does calls buy_equipment offering to buy any of the unowned passwords and disguises the player has' do
      player_model = PlayerMock::new(money: 14, equipment: ['french password', 'german disguise'])
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with[:purchase_options]).to match_array([
        'german password',
        'spanish password',
        'italian password',
        'american password',
        'russian password',
        'french disguise',
        'spanish disguise',
        'italian disguise',
        'american disguise',
        'russian disguise',
      ])
    end
    it 'does calls buy_equipment giving a buy limit of 1' do
      player_model = PlayerMock::new(money: 14, equipment: ['french password', 'german disguise'])
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
    end
  end
  describe 'player has between 15 and 29 money' do
    it 'calls do_nothing if the player already has all of the passwords, disguises, and codebooks' do
      player_model = PlayerMock::new(
        money: 29,
        equipment: [
          'french password',
          'german password',
          'spanish password',
          'italian password',
          'american password',
          'russian password',
          'french disguise',
          'german disguise',
          'spanish disguise',
          'italian disguise',
          'american disguise',
          'russian disguise',
          'french codebook',
          'german codebook',
          'spanish codebook',
          'italian codebook',
          'american codebook',
          'russian codebook'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(do_nothing.called_with).not_to eql({})
    end
    it 'does not call buy_equipment if the player already has all of the passwords, disguises, and codebooks' do
      player_model = PlayerMock::new(
        money: 29,
        equipment: [
          'french password',
          'german password',
          'spanish password',
          'italian password',
          'american password',
          'russian password',
          'french disguise',
          'german disguise',
          'spanish disguise',
          'italian disguise',
          'american disguise',
          'russian disguise',
          'french codebook',
          'german codebook',
          'spanish codebook',
          'italian codebook',
          'american codebook',
          'russian codebook'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with).to eql({})
    end
    it 'does calls buy_equipment offering to buy any of the unowned passwords if the player has' do
      player_model = PlayerMock::new(
        money: 29,
        equipment: [
          'french password',
          'german disguise',
          'spanish codebook'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with[:purchase_options]).to match_array([
        'german password',
        'spanish password',
        'italian password',
        'american password',
        'russian password',
        'french disguise',
        'spanish disguise',
        'italian disguise',
        'american disguise',
        'russian disguise',
        'french codebook',
        'german codebook',
        'italian codebook',
        'american codebook',
        'russian codebook'
      ])
    end
    it 'does calls buy_equipment giving a buy limit of 1' do
      player_model = PlayerMock::new(
        money: 29,
        equipment: [
          'french password',
          'german disguise',
          'italian codebook'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
    end
  end
  describe 'player has between 30 or more money' do
    it 'calls do_nothing if the player already has all of the passwords, disguises, and codebooks, and keys' do
      player_model = PlayerMock::new(
        money: 200,
        equipment: [
          'french password',
          'german password',
          'spanish password',
          'italian password',
          'american password',
          'russian password',
          'french disguise',
          'german disguise',
          'spanish disguise',
          'italian disguise',
          'american disguise',
          'russian disguise',
          'french codebook',
          'german codebook',
          'spanish codebook',
          'italian codebook',
          'american codebook',
          'russian codebook',
          'french key',
          'german key',
          'spanish key',
          'italian key',
          'american key',
          'russian key'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(do_nothing.called_with).not_to eql({})
    end
    it 'does not call buy_equipment if the player already has all of the passwords, disguises, and codebooks, and keys' do
      player_model = PlayerMock::new(
        money: 200,
        equipment: [
          'french password',
          'german password',
          'spanish password',
          'italian password',
          'american password',
          'russian password',
          'french disguise',
          'german disguise',
          'spanish disguise',
          'italian disguise',
          'american disguise',
          'russian disguise',
          'french codebook',
          'german codebook',
          'spanish codebook',
          'italian codebook',
          'american codebook',
          'russian codebook',
          'french key',
          'german key',
          'spanish key',
          'italian key',
          'american key',
          'russian key'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with).to eql({})
    end
    it 'does calls buy_equipment offering to buy any of the unowned passwords if the player has' do
      player_model = PlayerMock::new(
        money: 200,
        equipment: [
          'french password',
          'german disguise',
          'spanish codebook',
          'italian key'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with[:purchase_options]).to match_array([
        'german password',
        'spanish password',
        'italian password',
        'american password',
        'russian password',
        'french disguise',
        'spanish disguise',
        'italian disguise',
        'american disguise',
        'russian disguise',
        'french codebook',
        'german codebook',
        'italian codebook',
        'american codebook',
        'russian codebook',
        'french key',
        'german key',
        'spanish key',
        'american key',
        'russian key',
      ])
    end
    it 'does calls buy_equipment giving a buy limit of 1' do
      player_model = PlayerMock::new(
        money: 200,
        equipment: [
          'french password',
          'german disguise',
          'italian codebook',
          'russian key'
        ]
      )
      black_market.(
        player_model: player_model,
        change_orders: change_orders,
        action_hash:  action_hash
      )
      expect(buy_equipment.called_with[:purchase_limit]).to eql(1)
    end
  end
end
