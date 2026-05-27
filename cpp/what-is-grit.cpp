#include <iostream>

double grit_score(double perseverance_effort, double consistency_interest) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interest;
}

int main() {
    std::cout << "Synthetic grit score: "
              << grit_score(0.75, 0.50)
              << std::endl;
    return 0;
}
