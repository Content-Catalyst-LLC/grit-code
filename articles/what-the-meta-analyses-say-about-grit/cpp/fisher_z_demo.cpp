#include <cmath>
#include <iostream>

double fisher_z(double r) {
    return 0.5 * std::log((1.0 + r) / (1.0 - r));
}

double inverse_fisher_z(double z) {
    double e = std::exp(2.0 * z);
    return (e - 1.0) / (e + 1.0);
}

int main() {
    double r = 0.22;
    double z = fisher_z(r);
    std::cout << "r: " << r << "\n";
    std::cout << "Fisher z: " << z << "\n";
    std::cout << "Back-transformed r: " << inverse_fisher_z(z) << "\n";
    return 0;
}
