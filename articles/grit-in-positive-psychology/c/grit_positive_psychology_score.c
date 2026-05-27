#include <stdio.h>

double grit_score(double perseverance_effort, double durable_interest) {
    return 0.60 * perseverance_effort + 0.40 * durable_interest;
}

int main(void) {
    double perseverance_effort = 0.78;
    double durable_interest = 0.66;
    printf("Synthetic grit score for positive psychology model: %.3f\n",
           grit_score(perseverance_effort, durable_interest));
    return 0;
}
