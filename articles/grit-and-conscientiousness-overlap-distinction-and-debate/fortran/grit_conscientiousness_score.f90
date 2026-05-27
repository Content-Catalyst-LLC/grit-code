program grit_conscientiousness_score
  implicit none
  real :: industriousness, orderliness, dependability, responsibility, achievement_striving
  real :: perseverance_effort, consistency_interests
  real :: conscientiousness, grit

  industriousness = 0.81
  orderliness = 0.52
  dependability = 0.67
  responsibility = 0.74
  achievement_striving = 0.79
  perseverance_effort = 0.91
  consistency_interests = 0.63

  conscientiousness = 0.30 * industriousness + 0.18 * orderliness + 0.18 * dependability + &
                      0.17 * responsibility + 0.17 * achievement_striving
  grit = 0.60 * perseverance_effort + 0.40 * consistency_interests

  print *, "Synthetic conscientiousness score:", conscientiousness
  print *, "Synthetic grit score:", grit
end program grit_conscientiousness_score
