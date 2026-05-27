program fisher_z_demo
  implicit none
  real :: r, z, e, back_r

  r = 0.22
  z = 0.5 * log((1.0 + r) / (1.0 - r))
  e = exp(2.0 * z)
  back_r = (e - 1.0) / (e + 1.0)

  print *, "r:", r
  print *, "Fisher z:", z
  print *, "Back-transformed r:", back_r
end program fisher_z_demo
