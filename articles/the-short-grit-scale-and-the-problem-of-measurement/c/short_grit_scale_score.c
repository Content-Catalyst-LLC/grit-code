#include <stdio.h>

double grit_s_score(double perseverance_effort, double consistency_interest) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interest;
}

int main(void) {
    double perseverance_effort = 0.74;
    double consistency_interest = 0.61;
    printf("Synthetic Short Grit Scale score: %.3f\n",
           grit_s_score(perseverance_effort, consistency_interest));
    return 0;
}
