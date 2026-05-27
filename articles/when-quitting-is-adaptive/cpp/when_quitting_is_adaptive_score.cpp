#include <iostream>

double grit_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

double quitting_pressure_index(
    double cumulative_cost,
    double health_risk,
    double goal_misalignment,
    double opportunity_cost,
    double future_value,
    double learning_potential,
    double purpose_alignment
) {
    return 0.24 * cumulative_cost
         + 0.26 * health_risk
         + 0.24 * goal_misalignment
         + 0.20 * opportunity_cost
         - 0.24 * future_value
         - 0.20 * learning_potential
         - 0.24 * purpose_alignment;
}

double alternative_goal_value_index(
    double alternative_meaning,
    double alternative_feasibility,
    double alternative_support,
    double transition_cost
) {
    return 0.30 * alternative_meaning
         + 0.28 * alternative_feasibility
         + 0.24 * alternative_support
         - 0.18 * transition_cost;
}

int main() {
    double grit = grit_score(0.82, 0.64);
    double quitting_pressure = quitting_pressure_index(0.22, 0.18, 0.10, 0.20, 0.76, 0.72, 0.82);
    double alternative_value = alternative_goal_value_index(0.70, 0.62, 0.78, 0.28);

    std::cout << "Synthetic grit score: " << grit << "\n";
    std::cout << "Synthetic quitting pressure index: " << quitting_pressure << "\n";
    std::cout << "Synthetic alternative goal value index: " << alternative_value << "\n";
    return 0;
}
