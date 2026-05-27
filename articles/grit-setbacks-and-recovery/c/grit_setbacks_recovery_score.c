#include <stdio.h>

double grit_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

double recovery_capacity_score(
    double emotional_recovery,
    double cognitive_recovery,
    double physical_restoration,
    double social_support,
    double practical_resources
) {
    return 0.22 * emotional_recovery
         + 0.22 * cognitive_recovery
         + 0.18 * physical_restoration
         + 0.20 * social_support
         + 0.18 * practical_resources;
}

double adaptive_persistence_index(
    double grit,
    double setback_severity,
    double recovery_capacity,
    double feedback_quality,
    double opportunity_access,
    double burnout
) {
    return 0.18 * grit
         - 0.22 * setback_severity
         + 0.28 * recovery_capacity
         + 0.18 * feedback_quality
         + 0.18 * opportunity_access
         - 0.20 * burnout;
}

int main(void) {
    double grit = grit_score(0.82, 0.64);
    double recovery = recovery_capacity_score(0.74, 0.82, 0.66, 0.58, 0.62);
    double persistence = adaptive_persistence_index(grit, -0.28, recovery, 0.61, 0.70, -0.30);

    printf("Synthetic grit score: %.3f\n", grit);
    printf("Synthetic recovery capacity score: %.3f\n", recovery);
    printf("Synthetic adaptive persistence index: %.3f\n", persistence);
    return 0;
}
