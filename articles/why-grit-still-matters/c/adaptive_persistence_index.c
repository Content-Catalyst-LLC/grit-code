#include <stdio.h>

double adaptive_persistence_index(
    double grit,
    double purpose,
    double feedback,
    double practice,
    double recovery,
    double environmental_support,
    double social_support,
    double chronic_stress,
    double blocked_opportunity
) {
    return 0.22 * grit
         + 0.16 * purpose
         + 0.16 * feedback
         + 0.14 * practice
         + 0.16 * recovery
         + 0.18 * environmental_support
         + 0.12 * social_support
         - 0.14 * chronic_stress
         - 0.12 * blocked_opportunity;
}

int main(void) {
    double index = adaptive_persistence_index(4.2, 4.5, 4.3, 4.2, 4.0, 4.1, 4.2, 2.4, 2.0);
    printf("Synthetic adaptive persistence index: %.3f\n", index);
    printf("Professional caution: synthetic demonstration only.\n");
    return 0;
}
