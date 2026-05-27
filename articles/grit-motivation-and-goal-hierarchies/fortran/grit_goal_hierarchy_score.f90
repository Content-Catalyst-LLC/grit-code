program grit_goal_hierarchy_score
  implicit none
  real :: perseverance_effort, consistency_interests, grit
  real :: intrinsic_interest, identified_value, purpose_orientation, extrinsic_pressure, motivation
  real :: superordinate_clarity, midlevel_planning, daily_action_alignment, hierarchy

  perseverance_effort = 0.82
  consistency_interests = 0.64
  intrinsic_interest = 0.71
  identified_value = 0.78
  purpose_orientation = 0.84
  extrinsic_pressure = 0.25
  superordinate_clarity = 0.86
  midlevel_planning = 0.74
  daily_action_alignment = 0.69

  grit = 0.60 * perseverance_effort + 0.40 * consistency_interests
  motivation = 0.30 * intrinsic_interest + 0.30 * identified_value + 0.30 * purpose_orientation + 0.10 * extrinsic_pressure
  hierarchy = 0.35 * superordinate_clarity + 0.30 * midlevel_planning + 0.35 * daily_action_alignment

  print *, "Synthetic grit score:", grit
  print *, "Synthetic motivation score:", motivation
  print *, "Synthetic goal-hierarchy coherence score:", hierarchy
end program grit_goal_hierarchy_score
