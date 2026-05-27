#include <math.h>
#include <stdio.h>

double fisher_z(double r) {
    return 0.5 * log((1.0 + r) / (1.0 - r));
}

double inverse_fisher_z(double z) {
    double e = exp(2.0 * z);
    return (e - 1.0) / (e + 1.0);
}

int main(void) {
    double r = 0.22;
    double z = fisher_z(r);
    printf("r: %.3f\n", r);
    printf("Fisher z: %.3f\n", z);
    printf("Back-transformed r: %.3f\n", inverse_fisher_z(z));
    return 0;
}
