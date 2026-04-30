#include <stdio.h>

// Toy grit score utility.
// Compile with: cc c/grit_score.c -o outputs/grit_score

double grit_score(double perseverance, double interest, double recovery, double disengagement_pressure) {
    return 0.40 * perseverance + 0.30 * interest + 0.20 * recovery - 0.20 * disengagement_pressure;
}

int main(void) {
    double score = grit_score(0.80, 0.65, 0.70, 0.25);
    printf("Toy grit score: %.3f\n", score);
    return 0;
}
