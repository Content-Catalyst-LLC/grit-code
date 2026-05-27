program adaptive_persistence_index
  implicit none
  real :: index

  index = 0.22 * 4.2 + 0.16 * 4.5 + 0.16 * 4.3 + 0.14 * 4.2 + &
          0.16 * 4.0 + 0.18 * 4.1 + 0.12 * 4.2 - 0.14 * 2.4 - 0.12 * 2.0

  print *, "Synthetic adaptive persistence index:", index
  print *, "Professional caution: synthetic demonstration only."
end program adaptive_persistence_index
