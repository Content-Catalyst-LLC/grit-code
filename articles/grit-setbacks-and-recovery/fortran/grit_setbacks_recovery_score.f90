program grit_setbacks_recovery_score
  implicit none
  real :: perseverance_effort, consistency_interests, grit
  real :: emotional_recovery, cognitive_recovery, physical_restoration, social_support, practical_resources
  real :: setback_severity, feedback_quality, opportunity_access, burnout
  real :: recovery, persistence

  perseverance_effort = 0.82
  consistency_interests = 0.64
  emotional_recovery = 0.74
  cognitive_recovery = 0.82
  physical_restoration = 0.66
  social_support = 0.58
  practical_resources = 0.62
  setback_severity = -0.28
  feedback_quality = 0.61
  opportunity_access = 0.70
  burnout = -0.30

  grit = 0.60 * perseverance_effort + 0.40 * consistency_interests
  recovery = 0.22 * emotional_recovery + 0.22 * cognitive_recovery + &
             0.18 * physical_restoration + 0.20 * social_support + &
             0.18 * practical_resources

  persistence = 0.18 * grit - 0.22 * setback_severity + 0.28 * recovery + &
                0.18 * feedback_quality + 0.18 * opportunity_access - 0.20 * burnout

  print *, "Synthetic grit score:", grit
  print *, "Synthetic recovery capacity score:", recovery
  print *, "Synthetic adaptive persistence index:", persistence
end program grit_setbacks_recovery_score
