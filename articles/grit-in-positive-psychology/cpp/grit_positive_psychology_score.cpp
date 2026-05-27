#include <iostream>

double grit_score(double perseverance_effort, double durable_interest) {
    return 0.60 * perseverance_effort + 0.40 * durable_interest;
}

int main() {
    std::cout << "Synthetic grit score for positive psychology model: "
              << grit_score(0.78, 0.66)
              << std::endl;
    return 0;
}
