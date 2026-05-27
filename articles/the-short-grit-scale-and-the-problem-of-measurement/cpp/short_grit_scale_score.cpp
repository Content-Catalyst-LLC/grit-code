#include <iostream>

double grit_s_score(double perseverance_effort, double consistency_interest) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interest;
}

int main() {
    std::cout << "Synthetic Short Grit Scale score: "
              << grit_s_score(0.74, 0.61)
              << std::endl;
    return 0;
}
