program what_is_grit
  implicit none
  real :: perseverance_effort, consistency_interest, grit_score

  perseverance_effort = 0.75
  consistency_interest = 0.50
  grit_score = 0.60 * perseverance_effort + 0.40 * consistency_interest

  print *, "Synthetic grit score:", grit_score
end program what_is_grit
