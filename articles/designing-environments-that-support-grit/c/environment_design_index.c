#include <stdio.h>

double environment_design_index(
    double autonomy,
    double competence,
    double feedback,
    double belonging,
    double mentoring,
    double recovery,
    double resources,
    double fairness,
    double safety,
    double adaptive_quitting
) {
    return 0.13 * autonomy
         + 0.13 * competence
         + 0.13 * feedback
         + 0.12 * belonging
         + 0.10 * mentoring
         + 0.13 * recovery
         + 0.10 * resources
         + 0.11 * fairness
         + 0.10 * safety
         + 0.05 * adaptive_quitting;
}

int main(void) {
    double index = environment_design_index(4.2, 4.1, 4.3, 4.1, 3.9, 4.0, 3.8, 4.1, 4.2, 3.9);
    printf("Synthetic environment design index: %.3f\n", index);
    printf("Professional caution: synthetic demonstration only.\n");
    return 0;
}
