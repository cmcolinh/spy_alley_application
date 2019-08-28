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
end

class ChangeOrdersMock
  def add_die_roll(player:, rolled:)
  end
  def add_use_move_card(player:, card_to_use:)
  end
  def move(player_model:, change_orders:, space_to_move:)
  end
  def pass(player_model:, change_orders:)
  end
  def buy_equipment(player_model:, change_orders:, equipment_to_buy:)
  end
  def confiscate_materials(player_model:, change_orders:, target_player_model:, equipment_to_confiscate:)
  end
  def make_accusation(player_model:, change_orders:, target_player_model:, guess:, free_guess:)
  end
  def choose_spy_identity(player_model:, change_orders:, identity_chosen:)
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
        @called = {}
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
