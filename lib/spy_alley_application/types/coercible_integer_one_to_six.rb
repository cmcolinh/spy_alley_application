# frozen string literal: true

module SpyAlleyApplication
  module Types
  end
end

SpyAlleyApplication::Types::CoercibleIntegerOneToSix =
  ::Types::Coercible::Integer.constrained(included_in: (1..6))
