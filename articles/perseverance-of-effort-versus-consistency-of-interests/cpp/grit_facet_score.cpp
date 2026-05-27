#include <iostream>

double grit_total_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

int main() {
    std::cout << "Synthetic grit total score: "
              << grit_total_score(0.82, 0.71)
              << std::endl;
    return 0;
}
