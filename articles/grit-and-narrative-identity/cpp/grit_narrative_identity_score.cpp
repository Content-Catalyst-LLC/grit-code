#include <iostream>

double grit_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

double narrative_identity_score(
    double narrative_coherence,
    double agency,
    double meaning_making,
    double future_orientation
) {
    return 0.28 * narrative_coherence
         + 0.26 * agency
         + 0.24 * meaning_making
         + 0.22 * future_orientation;
}

double persistence_readiness_index(
    double grit,
    double narrative_identity,
    double social_support,
    double institutional_trust,
    double burnout,
    double narrative_strain
) {
    return 0.20 * grit
         + 0.26 * narrative_identity
         + 0.18 * social_support
         + 0.16 * institutional_trust
         - 0.16 * burnout
         - 0.12 * narrative_strain;
}

int main() {
    double grit = grit_score(0.82, 0.64);
    double narrative_identity = narrative_identity_score(0.76, 0.82, 0.70, 0.84);
    double readiness = persistence_readiness_index(grit, narrative_identity, 0.58, 0.72, -0.30, -0.28);

    std::cout << "Synthetic grit score: " << grit << "\n";
    std::cout << "Synthetic narrative identity score: " << narrative_identity << "\n";
    std::cout << "Synthetic persistence readiness index: " << readiness << "\n";
    return 0;
}
