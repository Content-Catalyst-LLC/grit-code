# Methods Note

This article folder demonstrates how grit, motivation, and goal hierarchy can be modeled as related but distinct contributors to long-term progress.

A long-term progress model can include grit, motivation, goal-hierarchy coherence, support, and burnout:

\[
Y_i = \beta_0 + \beta_1G_i + \beta_2M_i + \beta_3H_i + \beta_4S_i - \beta_5B_i + \epsilon_i
\]

where \(Y_i\) is long-term progress, \(G_i\) is grit, \(M_i\) is motivation, \(H_i\) is goal-hierarchy coherence, \(S_i\) is social or institutional support, and \(B_i\) is burnout.

Goal coherence can be represented as alignment between lower-level actions and higher-level goals:

\[
H_i = \frac{\sum_{j=1}^{n} a_{ij}g_{ij}}{n}
\]

where \(a_{ij}\) is the strength of a lower-level action and \(g_{ij}\) is its alignment with a higher-level goal.

A dynamic motivation model can be written as:

\[
M_{t+1} = \rho M_t + \alpha P_t + \gamma F_t + \sigma S_t - \delta B_t + \eta_t
\]

where future motivation depends on prior motivation, perceived progress, feedback, support, burnout, and changing conditions.

The workflows use synthetic data to show that grit is more informative when interpreted alongside motivation, goal hierarchy coherence, support, feedback, and burnout.
