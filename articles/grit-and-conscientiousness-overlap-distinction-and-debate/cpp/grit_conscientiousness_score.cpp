#include <iostream>

double conscientiousness_score(
    double industriousness,
    double orderliness,
    double dependability,
    double responsibility,
    double achievement_striving
) {
    return 0.30 * industriousness
         + 0.18 * orderliness
         + 0.18 * dependability
         + 0.17 * responsibility
         + 0.17 * achievement_striving;
}

double grit_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

int main() {
    double c = conscientiousness_score(0.81, 0.52, 0.67, 0.74, 0.79);
    double g = grit_score(0.91, 0.63);

    std::cout << "Synthetic conscientiousness score: " << c << "\n";
    std::cout << "Synthetic grit score: " << g << "\n";
    return 0;
}
