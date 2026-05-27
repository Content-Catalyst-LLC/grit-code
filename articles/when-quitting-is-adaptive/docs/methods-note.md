# Methods Note

This article folder demonstrates how adaptive quitting can be modeled as a decision process involving goal disengagement, goal reengagement, overpersistence risk, and sustainable persistence.

A simple quitting-pressure model can compare the costs of continuing with the value of staying:

\[
Q_i = (C_i + H_i + M_i + O_i) - (V_i + L_i + P_i)
\]

where \(Q_i\) is quitting pressure, \(C_i\) is cumulative cost, \(H_i\) is health risk, \(M_i\) is goal misalignment, \(O_i\) is opportunity cost, \(V_i\) is expected future value of continuing, \(L_i\) is learning potential, and \(P_i\) is purpose alignment.

Adaptive quitting can be represented as a threshold decision:

\[
\text{Disengage if } Q_i > \tau_i
\]

where \(\tau_i\) is the person-specific decision threshold, shaped by risk tolerance, financial security, social support, identity pressure, and available alternatives.

Goal reengagement can be represented as the expected value of alternative pathways:

\[
A_i = w_M M_i + w_F F_i + w_S S_i + w_R R_i - w_K K_i
\]

where \(A_i\) is alternative-goal value, \(M_i\) is meaning, \(F_i\) is feasibility, \(S_i\) is support, \(R_i\) is recovery potential, \(K_i\) is transition cost, and the weights represent their relative importance.

The workflows use synthetic data to show that adaptive quitting is not low grit. It can be a mature self-regulation process when continuing carries high cost, health risk, misalignment, and opportunity cost, especially when meaningful alternative goals and transition support are available.
