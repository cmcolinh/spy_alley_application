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

RSpec.describe SpyAlleyApplication::Actions do
  let(:player) {
    Class.new{
      def game
        1
      end

      def seat
        1
      end  
    }.new
  }
  let(:change_orders) {
    Class.new{
      def initialize
        @called = {}
      end
      def add_die_roll(player:, rolled:)
        @called[:add_die_roll] = ((@called[:add_die_roll] || 0) + 1)
      end
      def called
        @called.dup
      end
    }.new
  }
  let(:roll_die, &->{->{1}})
  let(:calling_method) {->{roll(player_model: player, change_orders: change_orders, roll_die: roll_die)}}
  describe '#roll' do
    it 'returns the number rolled' do
      expect(calling_method.()).to eql(1)
    end

    it 'calls change_orders' do
      roll(player_model: player, change_orders: change_orders, roll_die: roll_die)
      expect(change_orders.called[:add_die_roll]).to eql(1)
    end
  end
end
    
