#include <iostream>

// Toy adaptive persistence score.
// Compile with: g++ cpp/adaptive_persistence.cpp -o outputs/adaptive_persistence

int main() {
    double persistence = 0.78;
    double expected_value = 0.70;
    double goal_fit = 0.65;
    double burnout_risk = 0.25;

    double adaptive_persistence = persistence * (expected_value + goal_fit) - burnout_risk;

    std::cout << "Adaptive persistence score: " << adaptive_persistence << "\n";
    return 0;
}
