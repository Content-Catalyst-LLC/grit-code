program situational_support_index
  implicit none
  real :: index

  index = 0.16 * 4.2 + 0.16 * 4.3 + 0.16 * 4.1 + 0.12 * 3.9 + &
          0.14 * 4.0 + 0.14 * 3.8 + 0.12 * 4.1 + 0.10 * 4.2

  print *, "Synthetic situational support index:", index
  print *, "Professional caution: synthetic demonstration only."
end program situational_support_index
