fn support_index(
    autonomy: f64,
    feedback: f64,
    belonging: f64,
    mentoring: f64,
    recovery: f64,
    resources: f64,
    fairness: f64,
    safety: f64,
) -> f64 {
    0.16 * autonomy
        + 0.16 * feedback
        + 0.16 * belonging
        + 0.12 * mentoring
        + 0.14 * recovery
        + 0.14 * resources
        + 0.12 * fairness
        + 0.10 * safety
}

fn main() {
    let index = support_index(4.2, 4.3, 4.1, 3.9, 4.0, 3.8, 4.1, 4.2);
    println!("Synthetic situational support index: {:.3}", index);
    println!("Professional caution: synthetic demonstration only.");
}
