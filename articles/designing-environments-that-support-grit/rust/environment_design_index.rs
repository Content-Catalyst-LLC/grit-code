fn environment_design_index(
    autonomy: f64,
    competence: f64,
    feedback: f64,
    belonging: f64,
    mentoring: f64,
    recovery: f64,
    resources: f64,
    fairness: f64,
    safety: f64,
    adaptive_quitting: f64,
) -> f64 {
    0.13 * autonomy
        + 0.13 * competence
        + 0.13 * feedback
        + 0.12 * belonging
        + 0.10 * mentoring
        + 0.13 * recovery
        + 0.10 * resources
        + 0.11 * fairness
        + 0.10 * safety
        + 0.05 * adaptive_quitting
}

fn main() {
    let index = environment_design_index(4.2, 4.1, 4.3, 4.1, 3.9, 4.0, 3.8, 4.1, 4.2, 3.9);
    println!("Synthetic environment design index: {:.3}", index);
    println!("Professional caution: synthetic demonstration only.");
}
