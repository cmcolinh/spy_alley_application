# frozen string literal: true

SpyAlleyApplication::Types::CoercibleIntegerOneToSix =
  ::Types::Coercible::Integer.constrained(included_in: (1..6))
