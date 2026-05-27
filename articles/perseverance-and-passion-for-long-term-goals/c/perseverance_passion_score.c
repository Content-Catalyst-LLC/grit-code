#include <stdio.h>

double grit_score(double perseverance_effort, double durable_passion) {
    return 0.60 * perseverance_effort + 0.40 * durable_passion;
}

int main(void) {
    double perseverance_effort = 0.80;
    double durable_passion = 0.65;
    printf("Synthetic perseverance-passion grit score: %.3f\n",
           grit_score(perseverance_effort, durable_passion));
    return 0;
}
