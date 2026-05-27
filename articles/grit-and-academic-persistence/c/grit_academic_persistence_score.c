#include <stdio.h>

double grit_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

double persistence_readiness_index(
    double grit,
    double self_control,
    double belonging,
    double social_support,
    double financial_stress,
    double burnout
) {
    return 0.22 * grit
         + 0.18 * self_control
         + 0.22 * belonging
         + 0.18 * social_support
         - 0.20 * financial_stress
         - 0.18 * burnout;
}

int main(void) {
    double grit = grit_score(0.82, 0.64);
    double readiness = persistence_readiness_index(grit, 0.72, 0.74, 0.58, -0.42, -0.30);

    printf("Synthetic grit score: %.3f\n", grit);
    printf("Synthetic academic persistence readiness index: %.3f\n", readiness);
    return 0;
}
