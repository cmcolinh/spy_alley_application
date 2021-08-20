# SpyAlleyApplication

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/roda/spy_alley_application`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spy_alley_application'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spy_alley_application

## SpyAlleyApplication::NewGame
```
require 'spy_alley_application/new_game'
new_game = SpyAlleyApplication::NewGame
```
You call it with an Array of Hashes with ids and seats (that must all be distinct)
```
new_game.(action_hash: {seat_assignments: [{id: 1, seat: 1}, {id: 2, seat: 2}]}, user: nil)
```
## SpyAlleyApplication::ExecuteAction
```
require 'spy_alley_application/execute_action'
execute_action = SpyAlleyApplication::ExecuteAction
```

### game_board format
players: (array of)
  id: 1,
  seat: 1,
  location: {id: 0},
  spy_identity: "spanish",
  money: 20,
  move cards: [1,2],
  equipment: ["german password", "german key"],
  wild_cards: 0,
  active?: true
move_card_pile: [1,3,2,5,6...]
free_gift_pile: ["russian password", "german key", "wild card"...]
game_state:
  name: "start_of_turn",
  seat: 1
  
<b>action_hash</b>
Legal options:
player_action:
  - roll_die
  - use_move_card
  - make_accusation
  - move
  - buy_equipment
  - confiscate_materials
  - choose_new_spy_identity
  - pass
equipment_to_buy: # only required if player_action = 'buy_equipment' (send an array of strings)
  - russian password
  - german key
  and so on
equipment_to_confiscate: # only required if player_action = 'buy_equipment' (send a single string)
  - russian password
  - german key
  and so on
card_to_use: {1, 2, 3, 4, 5, 6} # required if player_action = 'use_move_card' (a single value)
space_id: {0, 1...30, 31} # required if player_action = 'move'
target_player_id: {1...} # required if player_action = 'make_accusation' or 'confiscate_materials'
nationality: # required if player_action = 'make_accusation' or 'choose_new_spy_identity' 
  - french
  - german
  - spanish
  - italian
  - american
  - russian

### user
User is an object calculated by users of this project that quack with the following interface
id() # the id of the user
admin?() # true or false dependending on whether the user is an admin

### last_action_id
the action_id of the last completed action.  The action hash should fail to validate if it doesn't match the action_id in the action_hash

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cmcolinh/spy_alley_application.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
