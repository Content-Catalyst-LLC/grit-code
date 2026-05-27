program perseverance_passion_score
  implicit none
  real :: perseverance_effort, durable_passion, grit_score

  perseverance_effort = 0.80
  durable_passion = 0.65
  grit_score = 0.60 * perseverance_effort + 0.40 * durable_passion

  print *, "Synthetic perseverance-passion grit score:", grit_score
end program perseverance_passion_score
