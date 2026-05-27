program grit_deliberate_practice_score
  implicit none
  real :: perseverance_effort, consistency_interests, grit
  real :: deliberate_practice, feedback_quality, coaching_access, practice_quality

  perseverance_effort = 0.82
  consistency_interests = 0.64
  deliberate_practice = 0.86
  feedback_quality = 0.61
  coaching_access = 0.55

  grit = 0.60 * perseverance_effort + 0.40 * consistency_interests
  practice_quality = 0.50 * deliberate_practice + 0.30 * feedback_quality + 0.20 * coaching_access

  print *, "Synthetic grit score:", grit
  print *, "Synthetic practice quality index:", practice_quality
end program grit_deliberate_practice_score
