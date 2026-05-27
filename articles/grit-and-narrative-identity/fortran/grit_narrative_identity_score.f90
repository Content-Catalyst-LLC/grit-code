program grit_narrative_identity_score
  implicit none
  real :: perseverance_effort, consistency_interests, grit
  real :: narrative_coherence, agency, meaning_making, future_orientation, narrative_identity
  real :: social_support, institutional_trust, burnout, narrative_strain, readiness

  perseverance_effort = 0.82
  consistency_interests = 0.64
  narrative_coherence = 0.76
  agency = 0.82
  meaning_making = 0.70
  future_orientation = 0.84
  social_support = 0.58
  institutional_trust = 0.72
  burnout = -0.30
  narrative_strain = -0.28

  grit = 0.60 * perseverance_effort + 0.40 * consistency_interests
  narrative_identity = 0.28 * narrative_coherence + 0.26 * agency + &
                       0.24 * meaning_making + 0.22 * future_orientation
  readiness = 0.20 * grit + 0.26 * narrative_identity + 0.18 * social_support + &
              0.16 * institutional_trust - 0.16 * burnout - 0.12 * narrative_strain

  print *, "Synthetic grit score:", grit
  print *, "Synthetic narrative identity score:", narrative_identity
  print *, "Synthetic persistence readiness index:", readiness
end program grit_narrative_identity_score
