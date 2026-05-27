#include <stdio.h>
#include <math.h>

double cohens_d(double mean_treatment, double mean_control, double pooled_sd) {
    if (pooled_sd == 0.0) return 0.0;
    return (mean_treatment - mean_control) / pooled_sd;
}

int main(void) {
    double d = cohens_d(4.2, 3.6, 0.8);
    printf("Synthetic intervention effect size estimate: %.3f\n", d);
    printf("Professional caution: synthetic demonstration only.\n");
    return 0;
}
