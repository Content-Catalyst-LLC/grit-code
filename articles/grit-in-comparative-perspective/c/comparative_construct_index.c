#include <stdio.h>

double adaptive_persistence_index(
    double grit,
    double self_control,
    double practice_quality,
    double purpose,
    double support,
    double recovery,
    double stress
) {
    return 0.22 * grit
         + 0.16 * self_control
         + 0.16 * practice_quality
         + 0.16 * purpose
         + 0.18 * support
         + 0.14 * recovery
         - 0.16 * stress;
}

int main(void) {
    double index = adaptive_persistence_index(4.2, 4.0, 4.1, 4.3, 4.0, 3.9, 2.4);
    printf("Synthetic adaptive persistence index: %.3f\n", index);
    printf("Professional caution: synthetic demonstration only.\n");
    return 0;
}
