#include <iostream>

double grit_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

double motivation_score(double intrinsic_interest, double identified_value, double purpose_orientation, double extrinsic_pressure) {
    return 0.30 * intrinsic_interest
         + 0.30 * identified_value
         + 0.30 * purpose_orientation
         + 0.10 * extrinsic_pressure;
}

double hierarchy_coherence_score(double superordinate_clarity, double midlevel_planning, double daily_action_alignment) {
    return 0.35 * superordinate_clarity
         + 0.30 * midlevel_planning
         + 0.35 * daily_action_alignment;
}

int main() {
    double grit = grit_score(0.82, 0.64);
    double motivation = motivation_score(0.71, 0.78, 0.84, 0.25);
    double hierarchy = hierarchy_coherence_score(0.86, 0.74, 0.69);

    std::cout << "Synthetic grit score: " << grit << "\n";
    std::cout << "Synthetic motivation score: " << motivation << "\n";
    std::cout << "Synthetic goal-hierarchy coherence score: " << hierarchy << "\n";
    return 0;
}
