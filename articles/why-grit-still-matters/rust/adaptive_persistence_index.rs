fn adaptive_persistence_index(
    grit: f64,
    purpose: f64,
    feedback: f64,
    practice: f64,
    recovery: f64,
    environment: f64,
    support: f64,
    stress: f64,
    blocked: f64,
) -> f64 {
    0.22 * grit
        + 0.16 * purpose
        + 0.16 * feedback
        + 0.14 * practice
        + 0.16 * recovery
        + 0.18 * environment
        + 0.12 * support
        - 0.14 * stress
        - 0.12 * blocked
}

fn main() {
    let index = adaptive_persistence_index(4.2, 4.5, 4.3, 4.2, 4.0, 4.1, 4.2, 2.4, 2.0);
    println!("Synthetic adaptive persistence index: {:.3}", index);
    println!("Professional caution: synthetic demonstration only.");
}
