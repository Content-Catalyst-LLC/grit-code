#include <iostream>

double grit_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

double overpersistence_index(
    double grit,
    double sunk_cost,
    double identity_pressure,
    double goal_rigidity,
    double feedback_responsiveness,
    double goal_fit
) {
    return 0.22 * grit
         + 0.24 * sunk_cost
         + 0.22 * identity_pressure
         + 0.20 * goal_rigidity
         - 0.22 * feedback_responsiveness
         - 0.20 * goal_fit;
}

double burnout_risk_index(
    double demand_intensity,
    double overpersistence,
    double goal_rigidity,
    double grit,
    double recovery_capacity,
    double social_support,
    double autonomy
) {
    return 0.24 * demand_intensity
         + 0.22 * overpersistence
         + 0.18 * goal_rigidity
         + 0.16 * grit
         - 0.26 * recovery_capacity
         - 0.20 * social_support
         - 0.18 * autonomy;
}

int main() {
    double grit = grit_score(0.82, 0.64);
    double overpersistence = overpersistence_index(grit, 0.38, 0.34, 0.30, 0.74, 0.80);
    double burnout = burnout_risk_index(0.42, overpersistence, 0.30, grit, 0.70, 0.62, 0.68);

    std::cout << "Synthetic grit score: " << grit << "\n";
    std::cout << "Synthetic overpersistence index: " << overpersistence << "\n";
    std::cout << "Synthetic burnout risk index: " << burnout << "\n";
    return 0;
}
