program comparative_construct_index
  implicit none
  real :: index

  index = 0.22 * 4.2 + 0.16 * 4.0 + 0.16 * 4.1 + 0.16 * 4.3 + &
          0.18 * 4.0 + 0.14 * 3.9 - 0.16 * 2.4

  print *, "Synthetic adaptive persistence index:", index
  print *, "Professional caution: synthetic demonstration only."
end program comparative_construct_index
