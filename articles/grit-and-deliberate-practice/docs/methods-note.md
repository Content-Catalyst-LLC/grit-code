# Methods Note

This article folder demonstrates how grit and deliberate practice can be modeled as related but separable contributors to performance and skill development.

A performance model can include grit, deliberate practice, prior skill, feedback, and context:

\[
Y_i = \beta_0 + \beta_1G_i + \beta_2D_i + \beta_3S_i + \beta_4F_i + \beta_5C_i + \epsilon_i
\]

where \(Y_i\) is performance or progress, \(G_i\) is grit, \(D_i\) is deliberate practice, \(S_i\) is prior skill, \(F_i\) is feedback quality, and \(C_i\) is contextual support.

A mediation-style model can represent the idea that grit may partly influence performance through deliberate practice:

\[
D_i = \alpha_0 + \alpha_1G_i + \alpha_2C_i + u_i
\]

\[
Y_i = \gamma_0 + \gamma_1G_i + \gamma_2D_i + \gamma_3C_i + v_i
\]

A sustainability model can add burnout:

\[
Y_{t+1} = \rho Y_t + \lambda D_t + \phi F_t + \sigma C_t - \delta B_t + \eta_t
\]

The workflows use synthetic data to show that grit may help explain who sustains hard practice, while deliberate practice, feedback, coaching, prior skill, support, and burnout shape whether effort becomes improvement.
