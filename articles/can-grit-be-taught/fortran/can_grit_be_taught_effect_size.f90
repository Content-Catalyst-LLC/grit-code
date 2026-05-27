program can_grit_be_taught_effect_size
  implicit none
  real :: mean_treatment, mean_control, pooled_sd, d

  mean_treatment = 4.2
  mean_control = 3.6
  pooled_sd = 0.8

  if (pooled_sd == 0.0) then
    d = 0.0
  else
    d = (mean_treatment - mean_control) / pooled_sd
  end if

  print *, "Synthetic intervention effect size estimate:", d
  print *, "Professional caution: synthetic demonstration only."
end program can_grit_be_taught_effect_size
