# frozen_string_literal: true

class PlayerMock
  def game
    1
  end

  def seat
    1
  end
end

class ChangeOrdersMock
  def add_die_roll(player:, rolled:)
  end
end

include SpyAlleyApplication::Actions

Rspec.describe SpyAlleyApplication::Actions do
  let(:player, ->{Class.new{
    def game
      1
    end

    def seat
      1
    end  
  }.new)
  let(:change_orders, ->{Class.new{
    def add_die_roll(player:, rolled:)
    end
  }.new)
  let(:roll_die, ->{->{1}})
  describe '#roll' do
    it 'returns the number rolled' do
      expect roll(player: player, change_orders: change_orders, roll_die: roll_die).to eql(1)
    end
  end
end
    
