fn adaptive_persistence_index(
    grit: f64,
    self_control: f64,
    practice_quality: f64,
    purpose: f64,
    support: f64,
    recovery: f64,
    stress: f64,
) -> f64 {
    0.22 * grit
        + 0.16 * self_control
        + 0.16 * practice_quality
        + 0.16 * purpose
        + 0.18 * support
        + 0.14 * recovery
        - 0.16 * stress
}

fn main() {
    let index = adaptive_persistence_index(4.2, 4.0, 4.1, 4.3, 4.0, 3.9, 2.4);
    println!("Synthetic adaptive persistence index: {:.3}", index);
    println!("Professional caution: synthetic demonstration only.");
}
