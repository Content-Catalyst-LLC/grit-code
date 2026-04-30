program grit_progress
  implicit none

  integer :: t
  real :: progress
  real, parameter :: effort = 0.72
  real, parameter :: commitment = 0.70
  real, parameter :: support = 0.55
  real, parameter :: friction = 0.30
  real, parameter :: rate = 0.07

  progress = 0.15

  print *, "Time", "Progress"

  do t = 1, 16
     progress = progress + rate * (effort + commitment + support - friction)
     if (progress > 1.0) progress = 1.0
     if (progress < 0.0) progress = 0.0
     print *, t, progress
  end do

end program grit_progress
