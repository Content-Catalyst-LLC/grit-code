#include <stdio.h>

double grit_total_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

int main(void) {
    double perseverance_effort = 0.82;
    double consistency_interests = 0.71;
    printf("Synthetic grit total score: %.3f\n",
           grit_total_score(perseverance_effort, consistency_interests));
    return 0;
}
