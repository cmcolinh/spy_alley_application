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

  def location
    '1'
  end
end

class ChangeOrdersMock
  def add_die_roll(player:, rolled:)
  end
  def add_use_move_card(player:, card_to_use:)
  end
  def add_move_action(player:, space:)
  end
  def add_money_action(player:, amount:, reason:)
  end
  def subtract_money_action(player:, amount:, paid_to:)
  end
  def add_pass_action
  end
  def add_equipment_action(player:, equipment:)
  end
  def add_action(**action)
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

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
