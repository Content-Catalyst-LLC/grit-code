#include <stdio.h>

double support_index(
    double autonomy,
    double feedback,
    double belonging,
    double mentoring,
    double recovery,
    double resources,
    double fairness,
    double safety
) {
    return 0.16 * autonomy
         + 0.16 * feedback
         + 0.16 * belonging
         + 0.12 * mentoring
         + 0.14 * recovery
         + 0.14 * resources
         + 0.12 * fairness
         + 0.10 * safety;
}

int main(void) {
    double index = support_index(4.2, 4.3, 4.1, 3.9, 4.0, 3.8, 4.1, 4.2);
    printf("Synthetic situational support index: %.3f\n", index);
    printf("Professional caution: synthetic demonstration only.\n");
    return 0;
}
