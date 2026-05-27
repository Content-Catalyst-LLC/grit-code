#include <iostream>

double grit_score(double perseverance_effort, double durable_passion) {
    return 0.60 * perseverance_effort + 0.40 * durable_passion;
}

int main() {
    std::cout << "Synthetic perseverance-passion grit score: "
              << grit_score(0.80, 0.65)
              << std::endl;
    return 0;
}
