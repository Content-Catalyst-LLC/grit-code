#include <stdio.h>

double self_control_score(double attention_regulation, double emotion_regulation, double impulse_control) {
    return 0.40 * attention_regulation + 0.30 * emotion_regulation + 0.30 * impulse_control;
}

double grit_score(double perseverance_effort, double consistency_interests) {
    return 0.60 * perseverance_effort + 0.40 * consistency_interests;
}

int main(void) {
    double sc = self_control_score(0.74, 0.62, 0.81);
    double g = grit_score(0.91, 0.68);

    printf("Synthetic self-control score: %.3f\n", sc);
    printf("Synthetic grit score: %.3f\n", g);
    return 0;
}
