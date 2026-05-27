program short_grit_scale_score
  implicit none
  real :: perseverance_effort, consistency_interest, grit_s_score

  perseverance_effort = 0.74
  consistency_interest = 0.61
  grit_s_score = 0.60 * perseverance_effort + 0.40 * consistency_interest

  print *, "Synthetic Short Grit Scale score:", grit_s_score
end program short_grit_scale_score
