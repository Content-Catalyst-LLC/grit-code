#include <stdio.h>

double grit_score(double perseverance_effort, double consistency_interest) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interest;
}

int main(void) {
    double perseverance_effort = 0.77;
    double consistency_interest = 0.63;
    printf("Synthetic Original Grit Scale score: %.3f\n",
           grit_score(perseverance_effort, consistency_interest));
    return 0;
}
