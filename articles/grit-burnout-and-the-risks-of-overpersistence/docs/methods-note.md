# Methods Note

This article folder demonstrates how grit, burnout, and overpersistence can be modeled as a sustainability problem rather than as a simple question of effort.

A simple burnout-risk model can include grit, demand intensity, goal rigidity, support, autonomy, and recovery capacity:

\[
B_i = \beta_0 + \beta_1G_i + \beta_2D_i + \beta_3R_i - \beta_4S_i - \beta_5A_i - \beta_6C_i + \epsilon_i
\]

where \(B_i\) represents burnout risk, \(G_i\) is grit, \(D_i\) is demand intensity, \(R_i\) is goal rigidity or role entrapment, \(S_i\) is support, \(A_i\) is autonomy, \(C_i\) is recovery capacity, and \(\epsilon_i\) is unexplained variation.

Overpersistence can be modeled as continued effort under high sunk cost, high identity pressure, low feedback responsiveness, and poor goal fit:

\[
O_i = \alpha_0 + \alpha_1G_i + \alpha_2K_i + \alpha_3I_i - \alpha_4F_i - \alpha_5Q_i + u_i
\]

where \(O_i\) represents overpersistence, \(K_i\) is sunk cost, \(I_i\) is identity pressure, \(F_i\) is feedback responsiveness, \(Q_i\) is goal quality or goal fit, and \(u_i\) is unexplained variation.

A sustainable-persistence model can include both effort and recovery:

\[
P_{t+1} = \rho P_t + \lambda E_t + \gamma F_t + \sigma S_t + \omega C_t - \delta B_t + \eta_t
\]

The workflows use synthetic data to show that sustainable persistence depends on recovery capacity, support, autonomy, feedback responsiveness, and goal fit. Overpersistence and burnout risk can undermine the long-term effort that grit is supposed to support.
