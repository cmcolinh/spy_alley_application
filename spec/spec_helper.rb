require "bundler/setup"
require "roda/spy_alley_application"
require 'spy_alley_application/actions'

class PlayerMock
  def game
    1
  end

  def seat
    1
  end

  def money
    50
  end

  def location
    '1'
  end

  def spy_identity
    'french'
  end

  def equipment
    ['spanish password', 'spanish codebook']
  end

  def wild_cards
    0
  end
end

class TargetPlayerMock
  def game
    1
  end

  def seat
    2
  end

  def money
    5
  end

  def location
    '1'
  end

  def spy_identity
    'german'
  end

  def equipment
    ['russian codebook']
  end

  def wild_cards
    1
  end
end

class ChangeOrdersMock
  def initialize
    @money_added      = 0
    @money_subtracted = 0
    @target           = {}
  end
  def add_die_roll(player:, rolled:)
  end
  def add_use_move_card(player:, card_to_use:)
  end
  def add_move_action(player:, space:)
  end
  def add_money_action(player:, amount:, reason:)
    @money_added += amount
    @target[:add_money_action] = player[:seat]
  end
  def subtract_money_action(player:, amount:, paid_to:)
    @money_subtracted += amount
    @target[:subtract_money_action] = player[:seat]
  end
  def add_pass_action
  end
  def add_equipment_action(player:, equipment:)
    @target[:add_equipment_action] = player[:seat]
  end
  def subtract_equipment_action(player:, equipment:)
    @target[:subtract_equipment_action] = player[:seat]
  end
  def add_action(**action)
  end
  def eliminate_player_action(player:)
    @target[:eliminate_player_action] = player[:seat]
  end
  def money_added
    @money_added.dup
  end
  def money_subtracted
    @money_subtracted.dup
  end
  def target
    @target.dup
  end
end

class Count
  @@initialized ||= []

  def self.enable(klass)
    return if @@initialized.include?(klass)
    @@initialized.push(klass)
    klass.prepend Module.new{
      (klass.instance_methods - klass.superclass.instance_methods - [:enable]).each do |method|
        define_method(method) do |*args|
          @called[method] = (@called[method] || 0) + 1
          super(*args)
        end
      end

      def initialize(*args)
        @called = Hash.new{|h, k| h[k] = 0}
        super(*args)
      end

      def times_called
        @called.dup
      end
    }
  end
end
Count.enable(ChangeOrdersMock)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
