program grit_positive_psychology_score
  implicit none
  real :: perseverance_effort, durable_interest, grit_score

  perseverance_effort = 0.78
  durable_interest = 0.66
  grit_score = 0.60 * perseverance_effort + 0.40 * durable_interest

  print *, "Synthetic grit score for positive psychology model:", grit_score
end program grit_positive_psychology_score
