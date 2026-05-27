program grit_facet_score
  implicit none
  real :: perseverance_effort, consistency_interests, grit_total

  perseverance_effort = 0.82
  consistency_interests = 0.71
  grit_total = 0.60 * perseverance_effort + 0.40 * consistency_interests

  print *, "Synthetic grit total score:", grit_total
end program grit_facet_score
