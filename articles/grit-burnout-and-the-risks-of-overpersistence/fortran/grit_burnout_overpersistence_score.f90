program grit_burnout_overpersistence_score
  implicit none
  real :: perseverance_effort, consistency_interests, grit
  real :: sunk_cost, identity_pressure, goal_rigidity, feedback_responsiveness, goal_fit
  real :: demand_intensity, recovery_capacity, social_support, autonomy
  real :: overpersistence, burnout

  perseverance_effort = 0.82
  consistency_interests = 0.64
  sunk_cost = 0.38
  identity_pressure = 0.34
  goal_rigidity = 0.30
  feedback_responsiveness = 0.74
  goal_fit = 0.80
  demand_intensity = 0.42
  recovery_capacity = 0.70
  social_support = 0.62
  autonomy = 0.68

  grit = 0.60 * perseverance_effort + 0.40 * consistency_interests
  overpersistence = 0.22 * grit + 0.24 * sunk_cost + 0.22 * identity_pressure + &
                    0.20 * goal_rigidity - 0.22 * feedback_responsiveness - 0.20 * goal_fit
  burnout = 0.24 * demand_intensity + 0.22 * overpersistence + 0.18 * goal_rigidity + &
            0.16 * grit - 0.26 * recovery_capacity - 0.20 * social_support - 0.18 * autonomy

  print *, "Synthetic grit score:", grit
  print *, "Synthetic overpersistence index:", overpersistence
  print *, "Synthetic burnout risk index:", burnout
end program grit_burnout_overpersistence_score
