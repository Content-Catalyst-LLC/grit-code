program grit_long_term_achievement_score
  implicit none
  real :: perseverance_effort, consistency_interests, grit
  real :: deliberate_practice, feedback_quality, social_support, opportunity_access, burnout
  real :: readiness

  perseverance_effort = 0.82
  consistency_interests = 0.64
  deliberate_practice = 0.86
  feedback_quality = 0.61
  social_support = 0.58
  opportunity_access = 0.70
  burnout = -0.28

  grit = 0.60 * perseverance_effort + 0.40 * consistency_interests
  readiness = 0.18 * grit + 0.28 * deliberate_practice + 0.18 * feedback_quality + &
              0.18 * social_support + 0.22 * opportunity_access - 0.16 * burnout

  print *, "Synthetic grit score:", grit
  print *, "Synthetic achievement readiness index:", readiness
end program grit_long_term_achievement_score
