program grit_self_control_score
  implicit none
  real :: attention_regulation, emotion_regulation, impulse_control
  real :: perseverance_effort, consistency_interests
  real :: self_control, grit

  attention_regulation = 0.74
  emotion_regulation = 0.62
  impulse_control = 0.81
  perseverance_effort = 0.91
  consistency_interests = 0.68

  self_control = 0.40 * attention_regulation + 0.30 * emotion_regulation + 0.30 * impulse_control
  grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

  print *, "Synthetic self-control score:", self_control
  print *, "Synthetic grit score:", grit
end program grit_self_control_score
