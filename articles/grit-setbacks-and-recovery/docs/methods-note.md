# Methods Note

This article folder demonstrates how grit, setbacks, and recovery can be modeled as a developmental recovery system rather than as a grit-only outcome.

A simple adaptive-persistence model can include grit, setback severity, recovery capacity, support, feedback, and burnout:

\[
P_i = \beta_0 + \beta_1G_i - \beta_2K_i + \beta_3R_i + \beta_4S_i + \beta_5F_i - \beta_6B_i + \epsilon_i
\]

where \(P_i\) represents adaptive persistence after setback, \(G_i\) is grit, \(K_i\) is setback severity, \(R_i\) is recovery capacity, \(S_i\) is support, \(F_i\) is feedback quality, and \(B_i\) is burnout.

Recovery capacity can be represented as a composite of emotional, cognitive, physical, social, and practical recovery resources:

\[
R_i = w_EE_i + w_CC_i + w_PP_i + w_SS_i + w_QQ_i
\]

where \(R_i\) represents recovery capacity, \(E_i\) is emotional recovery, \(C_i\) is cognitive clarity, \(P_i\) is physical restoration, \(S_i\) is social support, \(Q_i\) is practical resources, and the weights represent their relative importance.

Recovery may also moderate the relationship between grit and persistence:

\[
P_i = \beta_0 + \beta_1G_i + \beta_2R_i + \beta_3(G_i \times R_i) + \epsilon_i
\]

The workflows use synthetic data to show that grit is more sustainable when recovery resources are present and that severe setbacks, burnout, weak feedback, and low support can disrupt adaptive persistence.
