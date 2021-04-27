# frozen string literal: true

require 'dry-validation'

SpyAlleyApplication::Validator::NoOptions =
  Class::new(Dry::Validation::Contract){params{}}::new

