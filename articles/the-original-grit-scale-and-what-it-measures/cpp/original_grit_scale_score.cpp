#include <iostream>

double grit_score(double perseverance_effort, double consistency_interest) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interest;
}

int main() {
    std::cout << "Synthetic Original Grit Scale score: "
              << grit_score(0.77, 0.63)
              << std::endl;
    return 0;
}
