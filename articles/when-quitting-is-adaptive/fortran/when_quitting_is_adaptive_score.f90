program when_quitting_is_adaptive_score
  implicit none
  real :: grit, quitting_pressure, alternative_value
  real :: perseverance_effort, consistency_interests

  perseverance_effort = 0.82
  consistency_interests = 0.64

  grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

  quitting_pressure = 0.24 * 0.22 + 0.26 * 0.18 + 0.24 * 0.10 + &
                      0.20 * 0.20 - 0.24 * 0.76 - 0.20 * 0.72 - 0.24 * 0.82

  alternative_value = 0.30 * 0.70 + 0.28 * 0.62 + 0.24 * 0.78 - 0.18 * 0.28

  print *, "Synthetic grit score:", grit
  print *, "Synthetic quitting pressure index:", quitting_pressure
  print *, "Synthetic alternative goal value index:", alternative_value
end program when_quitting_is_adaptive_score
