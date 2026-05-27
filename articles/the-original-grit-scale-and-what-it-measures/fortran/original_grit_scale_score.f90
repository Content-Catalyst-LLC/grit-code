program original_grit_scale_score
  implicit none
  real :: perseverance_effort, consistency_interest, grit_score

  perseverance_effort = 0.77
  consistency_interest = 0.63
  grit_score = 0.60 * perseverance_effort + 0.40 * consistency_interest

  print *, "Synthetic Original Grit Scale score:", grit_score
end program original_grit_scale_score
