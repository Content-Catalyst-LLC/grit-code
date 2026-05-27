#include <iostream>

double grit_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

double achievement_readiness_index(
    double grit,
    double deliberate_practice,
    double feedback_quality,
    double social_support,
    double opportunity_access,
    double burnout
) {
    return 0.18 * grit
         + 0.28 * deliberate_practice
         + 0.18 * feedback_quality
         + 0.18 * social_support
         + 0.22 * opportunity_access
         - 0.16 * burnout;
}

int main() {
    double grit = grit_score(0.82, 0.64);
    double readiness = achievement_readiness_index(grit, 0.86, 0.61, 0.58, 0.70, -0.28);

    std::cout << "Synthetic grit score: " << grit << "\n";
    std::cout << "Synthetic achievement readiness index: " << readiness << "\n";
    return 0;
}
