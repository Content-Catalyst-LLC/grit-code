program environment_design_index
  implicit none
  real :: index

  index = 0.13 * 4.2 + 0.13 * 4.1 + 0.13 * 4.3 + 0.12 * 4.1 + &
          0.10 * 3.9 + 0.13 * 4.0 + 0.10 * 3.8 + 0.11 * 4.1 + &
          0.10 * 4.2 + 0.05 * 3.9

  print *, "Synthetic environment design index:", index
  print *, "Professional caution: synthetic demonstration only."
end program environment_design_index
