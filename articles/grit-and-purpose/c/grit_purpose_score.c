#include <stdio.h>

double grit_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

double purpose_score(double personal_meaning, double long_term_direction, double beyond_self_contribution) {
    return 0.34 * personal_meaning
         + 0.33 * long_term_direction
         + 0.33 * beyond_self_contribution;
}

double persistence_readiness_index(
    double grit,
    double purpose,
    double social_support,
    double autonomy_support,
    double burnout
) {
    return 0.22 * grit
         + 0.28 * purpose
         + 0.18 * social_support
         + 0.18 * autonomy_support
         - 0.18 * burnout;
}

int main(void) {
    double grit = grit_score(0.82, 0.64);
    double purpose = purpose_score(0.74, 0.82, 0.88);
    double readiness = persistence_readiness_index(grit, purpose, 0.58, 0.72, -0.30);

    printf("Synthetic grit score: %.3f\n", grit);
    printf("Synthetic purpose score: %.3f\n", purpose);
    printf("Synthetic persistence readiness index: %.3f\n", readiness);
    return 0;
}
