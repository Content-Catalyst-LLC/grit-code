#include <stdio.h>
int main(void) {
    double perseverance = 0.78;
    double consistency = 0.64;
    double grit = 0.60 * perseverance + 0.40 * consistency;
    printf("Synthetic grit score: %.3f\n", grit);
    return 0;
}
