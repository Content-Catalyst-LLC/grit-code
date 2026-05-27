#include <stdio.h>

double grit_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

double practice_quality_index(double deliberate_practice, double feedback_quality, double coaching_access) {
    return 0.50 * deliberate_practice + 0.30 * feedback_quality + 0.20 * coaching_access;
}

int main(void) {
    double grit = grit_score(0.82, 0.64);
    double practice_quality = practice_quality_index(0.86, 0.61, 0.55);

    printf("Synthetic grit score: %.3f\n", grit);
    printf("Synthetic practice quality index: %.3f\n", practice_quality);
    return 0;
}
