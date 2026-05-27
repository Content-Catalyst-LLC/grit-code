program duckworth_grit_score
  implicit none
  real :: perseverance_effort, consistency_interest, grit_score

  perseverance_effort = 0.82
  consistency_interest = 0.61
  grit_score = 0.60 * perseverance_effort + 0.40 * consistency_interest

  print *, "Duckworth-style synthetic grit score:", grit_score
end program duckworth_grit_score
