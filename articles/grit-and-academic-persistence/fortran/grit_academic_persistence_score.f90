program grit_academic_persistence_score
  implicit none
  real :: perseverance_effort, consistency_interests, grit
  real :: self_control, belonging, social_support, financial_stress, burnout
  real :: readiness

  perseverance_effort = 0.82
  consistency_interests = 0.64
  self_control = 0.72
  belonging = 0.74
  social_support = 0.58
  financial_stress = -0.42
  burnout = -0.30

  grit = 0.60 * perseverance_effort + 0.40 * consistency_interests
  readiness = 0.22 * grit + 0.18 * self_control + 0.22 * belonging + &
              0.18 * social_support - 0.20 * financial_stress - 0.18 * burnout

  print *, "Synthetic grit score:", grit
  print *, "Synthetic academic persistence readiness index:", readiness
end program grit_academic_persistence_score
