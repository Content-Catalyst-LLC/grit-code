program grit_purpose_score
  implicit none
  real :: perseverance_effort, consistency_interests, grit
  real :: personal_meaning, long_term_direction, beyond_self_contribution, purpose
  real :: social_support, autonomy_support, burnout, readiness

  perseverance_effort = 0.82
  consistency_interests = 0.64
  personal_meaning = 0.74
  long_term_direction = 0.82
  beyond_self_contribution = 0.88
  social_support = 0.58
  autonomy_support = 0.72
  burnout = -0.30

  grit = 0.60 * perseverance_effort + 0.40 * consistency_interests
  purpose = 0.34 * personal_meaning + 0.33 * long_term_direction + 0.33 * beyond_self_contribution
  readiness = 0.22 * grit + 0.28 * purpose + 0.18 * social_support + 0.18 * autonomy_support - 0.18 * burnout

  print *, "Synthetic grit score:", grit
  print *, "Synthetic purpose score:", purpose
  print *, "Synthetic persistence readiness index:", readiness
end program grit_purpose_score
